[TOC]

# Maps

## 基本概念

map是引用类型的，声明如下：
```
var map1 map[keytype]valuetype
var map1 map[string]int
```
[keytype] valuetype之间允许有空格，但是gofmt会将其删除。声明中不需要知道map的长度：map可以动态增长。没有初始化之前，其值是nil。

keytype一般是能支持==操作的类型，例如:  string, int, float。但 arrays, slices and structs不能作为keytype。valuetype可以是任意类型。

由于map类型的变量是的值是引用，所以向函数中传递map类型的变量，非常廉价（因为向函数传递的是一个地址）。在map中查找一个元素要比在数组或slice中要快，但直接访问在i位置的元素，在数组中要快很多。

* map的长度

```
len(map1)
```

给出了map的key-value对的个数，但该值在不断的变化，因为经常在map中删除和添加元素。

下面是一个使用map的简单例子:

```
package main
import “fmt”

func main() {
	var mapLit map[string]int
	//var mapCreated map[string]float32
	var mapAssigned map[string]int

	mapLit = map[string]int{“one”: 1, “two”: 2}
	mapCreated := make(map[string]float32)
	mapAssigned = mapLit

	mapCreated[“key1”] = 4.5
	mapCreated[“key2”] = 3.14159
	mapAssigned[“two”] = 3

	fmt.Printf(“Map literal at \“one\” is: %d\n”, mapLit[“one”])
	fmt.Printf(“Map created at \“key2\” is: %f\n”, mapCreated[“key2”])
	fmt.Printf(“Map assigned at \“two\” is: %d\n”, mapLit[“two”])
	fmt.Printf(“Map literal at \“ten\” is: %d\n”, mapLit[“ten”])
}
```

## map的声明和初始化

### map的初始化

```
var map1[keytype]valuetype = make(map[keytype]valuetype)
或
map1 := make(map[keytype]valuetype)
```

### map的创建

```
mapCreated := make(map[string]float)
或
mapCreated := map[string]float{}
```

注意：不要使用new来创建map。

* 使用函数作为value

```
package main
import “fmt”

func main() {
	mf := map[int]func() int{
		1: func() int { return 10 },
		2: func() int { return 20 },
		5: func() int { return 50 },
	}
	fmt.Println(mf) //输出：map[1:0x10903be0 5:0x10903ba0 2:0x10903bc0] 这些值是函数的地址
}
```

### Map的容量

不像数组，map没有固定的容量大小或长度，map的容量是动态的增加和减少。但在创建map时可以指定初始化容量的大小。
请编码的形式如下：
```
make(map[keytype]valuetype, cap)
```

实际的例子如下：

```
map2 := make(map[string]float, 100)
```
指定初始化容量后，当元素的个数大于等于当前容量时，map会动态的增加


### Map的操作

### Slices作为map的value

一个key只能对应一个值，如何让一个key对应多个值呢？可以把value的类型定义成Slice类型。定义的形式如下：

```
mp1 := make(map[int][]int)
mp2 := make(map[int]*[]int)
```

以下是一个完整的例子：

```
package main

import (
	"fmt"
)

func doMaps() {
	s1 := []int{1, 2, 3, 4, 5}
	map1 := make(map[string][]int)
	map1["first"] = s1
	fmt.Println(map1)
}

func main() {
	doMaps()
}
```

### 检查map中的key-value的值是否存在

若类似于下面的访问：

```
 val1 = map1[key1]
```

若key1的值不存在，则val1会被初始化为0值。（注：0值的意思是：若是int则值为0，若为Slice值为[]...)。
这样就有个问题：如何区分，map1[key1]的值本来就是为0，还是map1[key1]的值本来就不存在？

可以使用以下的表达式来返回元素是否存在：

```
val1, isPresent = map1[key1]
```
也就是，在获取map1[key1]的值时，获取该key1是否存在的状态值即可。Go已经为我们提供了该值。

其中的isPresent是一个boolean值，该值代表key1是否存在，若不需要检测是否存在，我们可以忽略该值。

### 删除map中的元素

可以通过以下函数删除map的元素：
```
delete(map1, key1)
```
但当key1不存在时，该函数不会报错。

### 遍历map的元素

```
 for key, value := range map1 {
	…
}
```

或

```
for _, value := range map1 {
	…
}
```

或

```
for key := range map1 {
	fmt.Printf(“key is: %d\n”, key)
}
```


### 基于map的切片

基于map的切片，需要使用两次make，第一次创建一个切片，第二次为每个元素创建map。
代码如下：

```
func main() {
	// Version A:
	items := make([]map[int]int, 5)
	for i := range items {
		items[i] = make(map[int]int, 1)
		items[i][1] = 2
	}

	fmt.Printf(“Version A: Value of items: %v\n”, items)
	// Version B: NOT GOOD!
	items2 := make([]map[int]int, 5)

	for _, item := range items2 {
		item = make(map[int]int, 1)
		// item is only a copy of the slice element.
		item[1] = 2
		// This ‘item’ will be lost on the next iteration.
	}
	fmt.Printf(“Version B: Value of items: %v\n”, items2)
}
```

### 如何对map进行排序
默认情况下，map的key是乱序的，若要对map进行排序，可以把key值复制到一个Slice中，让后再对key进行排序后使用。
代码如下：

```
package main

import (
	“fmt”
	“sort”
)

var (
	barVal = map[string]int{“alpha”: 34, “bravo”: 56, “charlie”: 23,
	“delta”: 87, “echo”: 56, “foxtrot”: 12, “golf”: 34, “hotel”: 16,
	“indio”: 87, “juliet”: 65, “kilo”: 43, “lima”: 98}
)

func main() {
	fmt.Println(“unsorted:”)
	for k, v := range barVal {   //打印原始值
		fmt.Printf(“Key: %v, Value: %v / “, k, v)
	}

	keys := make([]string, len(barVal)) //创建Slice
	i := 0
	for k, _ := range barVal {  // 把map的key值复制到Slice中
		keys[i] = k
		i++
	}
	sort.Strings(keys) // 对Slice中的key值进行排序
	fmt.Println()
	fmt.Println(“sorted:”)
	for _, k := range keys {	//使用排好序的key，用key值来获取value的值
		fmt.Printf(“Key: %v, Value: %v / “, k, barVal[k])
	}
}
```

若你想要的是排好序的list，最好使用下面的结构：

```
type struct {
	key string
	value int
}
```

### 交换map的key-value的值

若map和value的类型相等，则交换起来很方便。

```
package main

import (
“fmt”
)

var (
	barVal = map[string]int{“alpha”: 34, “bravo”: 56, “charlie”: 23,
	“delta”: 87, “echo”: 56, “foxtrot”: 12, “golf”: 34, “hotel”: 16,
	“indio”: 87, “juliet”: 65, “kilo”: 43, “lima”: 98}
)

func main() {
	invMap := make(map[int]string, len(barVal))
	for k, v := range barVal {
		invMap[v] = k
	}

	fmt.Println(“inverted:”)
	for k, v := range invMap {
		fmt.Printf(“Key: %v, Value: %v / “, k, v)
	}
}
```
当valude的值是多值类型时，例如： map[int][]string，以上代码当然是有问题的。此时要对多值进行处理。

