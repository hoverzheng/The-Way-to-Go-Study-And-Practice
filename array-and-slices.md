# 数组和切片(Array and Slices)
## Arrays
### 基本概念
数组是固定长度同类型元素的集合，元素的类型可以是任意的。而数组的长度是非负的整数值，或是常量表达式。

数组的长度必须在编译阶段决定，这样才能在编译阶段为数组分配空间，数组的初始化也在编译阶段完成。

数组最大的大小是2Gb。 

和其他语言一样，Go数组的下标是从0开始的。

数组声明的例子：
```
var arr1 [5] int
```
在这个例子中，数组的下标是：0~4
总的来说数组的下标范围是：

```
0 ~ len(arr1)-1
```
若声明为整数，则在编译阶段会把数组初始化为0。

下面的例子，打印数组的值：
```
// 打印数组的值
func doArray() {
	var arr [5]int
	for i := 0; i < len(arr); i++ {
		fmt.Println(arr[i])
	}
}
```
从上面的例子可以看到，数组的值都为0。



#### 遍历数组
如何遍历一个数组，在Go中提供了两种方式：

* 通过下标遍历数组
```
for i := 0; i < len(arr); i++ {
    fmt.Println(arr[i])
}
```

* 通过range()遍历数组
```
for i:= range arr {
   fmt.Println(arr[i]) 
}
```

#### 数组复制


### 数组初始化


### 多维数组

### 数组作为参数
当给函数传递一个大的数组时，会占用大量内存，这有两种解决办法：
* 传递数组的指针
* 使用数组的slice

第2种方法将在后面介绍，这里看一个传递指针的例子：

```
// 待补充
```


## Slices(切片)
### 基本概念
切片是数组的一部分，是数组的连续段（我们将调用底层数组，通常是匿名的）的引用，所以切片是引用类型（因此更类似于C/C++中的数组类型，或Python中的列表类型)。
这部分可以是整个数组，也可以是开始和结束索引所指示的项目的子集(结束索引处的项目不包括在片段中)。切片为底层数组提供了一个动态窗口。

下面是一个切片的例子：
```
func printArray(arr []int) {
	for i := range arr {
		fmt.Printf("%d ", arr[i])
	}
	fmt.Println("\n")
}


func doSlice() {
	var arr1 = [10]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

	slice1 := arr1[0:2]
	fmt.Println(cap(slice1))    // 10
	printArray(slice1)  // 1 2
}
```

切片具有以下特性：
* 切片是可索引的，可以通过len()函数来获取长度。
```
fmt.Println(len(slice1)) // 2
```

* 切片是可变长度数组：最小长度为0，最大为原始数组长度
*  cap()函数可以用来显示切片可以扩展的容量大小
```
fmt.Println(cap(slice1)) // 10
```

*  切片的长度范围：0 <= len(s) <= cap(s)
*  基于相同数组得到的不同的切片**共享数组的数据**，但不同数组的数据是独立的，不同数组之间绝不会共享数据。

这意味着：若修改其中一个切片的值，其他基于原始数据该位置的创建的切片值也会改变。请看下面的例子：

```
var arr1 = []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

slice2 := arr1[0:3]
slice1 := arr1[0:2]
slice1[0] = 11    // 修改切片的值，也就修改了原来数组的值
printArray(slice1)  // 11 2
printArray(slice2)  // 11 2 3
```
从上面的例子看出，改变切片的值后，原来数组的值，和其他切片对应位置的值也改变了。

* 切片可以由切片构成，但还是指向相同的底层数组。
```
slice1 = slice2  // slice1指向了slice2，但都指向相同的底层数组：arr1
```

* 对所有的切片，以下总是对的：
```
s == s[:i] + s[i:] // i is an int: 0 <= i <= len(s)
且
len(s) <= cap(s)
```

* 优点：由于切片是引用(references)类型，因此不会占用额外的内存，所以比使用数组效率更高，因此在Go代码中它们的使用远不止于数组。


### 切片的声明
切片的声明格式如下：

```
var identifier []type
```
注意此时切片还没有被初始化，其默认值是nil。为什么是空呢？记住：切片是引用类型。

### 切片的初始化

切片的初始化格式如下：

```
var slice1 []type = arr1[start:end]
```

实际例子如下：
```
s := []int{1,2,3} // 这种显然更方便
或
s := [3]int{1,2,3} 
或
s := […]int{1,2,3}[:]
```
以上代码，创建了一个{1,2,3}的数组，并让切片指向它。

### 切片的操作
* 复制整个数组
```
 var slice1 []type = arr1[:]
```
或
```
 slice1 = &arr1
```

这也更能够理解，切片是引用类型的事实。

* 获取从i位置开始后面的元素
```
// 注意：这里是包括索引为2的位置的值
arr1[2:]  
或
arr1[2:len(arr1)] 
```

* 获取从i位置，到开始的所有元素
注意：这里不包括i索引位置的值。

```
arr1[:3]  //注意：这里不包括最后的索引元素
或
arr1[0:3]
```

* 去掉数组的最后一个元素

```
slice1 = slice1[:len(slice1)-1]
```
这里只要记住：不包含最后的索引处的元素。


### 切片的存储结构

```
struct slice {
    ptr *  // 指向元素的指针
    len int //目前slice的元素个数
    cap int // slice的最大容量
}
```

通过这个结构可以实现slice的操作，这也就是为什么可以使用len和cap函数的原因。


### 移动切片的元素

可以通过切片的运算来实现切片元素的移动。例如：
```
slice1 = slice1[1:] // 这样就把slice1的值向前移动了一个位置。
```

但要注意，不能把元素向后移动，以下代码是错误的：

```
slice1 = slice1[-1:] // 这种做法是错误的
```

另外注意：不要在slice上使用指针，因为slice就是指针。

### 向函数传递切片

当我们希望向函数传递一个数组参数时，我们可以把该参数声明为切片类型：

```
func printArray(arr []int) {
	for i := range arr {
		fmt.Printf("%d ", arr[i])
	}
	fmt.Println("")
}

// 如何使用
func main() {
    var arr = [5]int{0,1,2,3,4}
    printArray(arr[:])
}

```
那么为什么不使用数组做为参数而要使用切片呢？
* 传递数组时，传递是元素需要占用很大内存，而且数组大小需要指定
* 传递切片时，传递的是引用，是一个切片的开始地址，效率更高。


## 通过make()来创建切片
有时候，我们的切片和数组也许都没有定义，此时可以通过make()函数来定义切片，并创建数组。

形式如下：
```
var slice1 []type = make([]type, len)
```
也可以按如下形式简写：

```
slice1 := make([]type, len)
```
注意：这里的len是数组和切片的长度。

而且能得到结论：
```
 cap(slice1) == len(slice1)
```

也可以在创建时确定容量大小，定义形式如下：

```
slice1 := make([]type, len, cap)
```

比如以下的两种形式定义同样的切片：
```
make([]int, 50, 100)
make([100]int, 50)
```

以上代码产生的切片，在内存中结构如下：
![](/assets/slice_in_memory.png)

### new()和 make()的不同
* new(T)
(1)返回的是一个指针(地址)：
```
new([]int)  //得到：*[]int
```
(2)可以用于任何类型

* make()
(1)初始化切片，且返回的是第一个元素的地址：
```
make([]int, 0) //得到：[0]int
```

(2) 可以用于slices,map,channels等类型

举例说明：
```
var p *[]int = new([]int) // *p == nil; with len and cap 0
p := new([]int)
```

切片的举例：
```
p := make([]int, 0)  // 切片已经初始化，且指向了一个空的数组
```

以下代码创建了一个长度为50的int数组，和一个长度为10、容量为50的切片，该切片指向该数组。
```
var v []int = make([]int, 10, 50)
或  
v := make([]int, 10, 50)
```

以下代码的创建一个长度和容量相等的切片：
```
s1 := make([]byte, 5) // s1容量和长度都为5
```

### 通过range遍历Slices

```
// 遍历slice并打印
func printSlice(s []int) {
	for i := range s {
		fmt.Printf("%d ", s[i])
	}
	fmt.Println()
}

// 通过range来初始化Slice
func travelSlices() {
	slice1 := make([]int, 4)
	for i := range slice1 {
		slice1[i] = i
	}
	printSlice(slice1)
}
```

* 通过range获取index和value

```
func stringSlice() {
	s2 := []string{"hello", "world", "and", "you"}
	for i, v := range s2 {
		fmt.Printf("s2[%d]=%s,", i, v)
	}
}
```
输出的值为：
```
s2[0]=hello,s2[1]=world,s2[2]=and,s2[3]=you
```

* 通过range获取value忽略index

```
func stringSlice2() {
	s2 := []string{"hello", "world", "and", "you"}
	for _, v := range s2 {
		fmt.Printf("%s,", v)
	}
}
```
使用_可以忽略返回的值。


### 修改Slice的长度(Reslicing)

我们知道，如下的事实：

```
slice1 := make([]type, start_length, capacity)
```

我们可以修改Slice的长度:扩展长度和缩小长度。扩展最大的长度是capacity。

* 扩展Slice的长度

```
sl = sl[0:len(sl)+1]  //把切片s1的长度加1
```
扩展的时候一定要注意，扩展的长度不能大于cap(s1)的长度，在扩展的时候需要进行判定。
若是基于数组构造的切片，cap一般是等于数组的长度。

* 缩小切片长度

```
sl = sl[0:len(sl)-1] // 把切片s1的长度-1
```

* 实际的例子
```
func stringSlice2() {
	s2 := []string{"hello", "world", "and", "you"}
	for _, v := range s2 {
		fmt.Printf("%s,", v)
	}

	fmt.Println("")
	fmt.Printf("cap=%d,len=%d\n", cap(s2), len(s2))

	// reduce s2
	// 在原来的切片基础上，把最后一个元素去掉
	s2 = s2[0 : len(s2)-1]
	printStringSlice(s2)   // 输出:hello world and

	// 去掉第一个元素和最后一个元素
	s2 = s2[1 : len(s2)-1]
	printStringSlice(s2)   // 输出: world
	fmt.Printf("cap=%d,len=%d\n", cap(s2), len(s2))  //输出：cap=3,len=1

	// extend s2
	// 下面两行会报错，为什么？
	//s2 = s2[0 : len(s2)-1]   
	//printStringSlice(s2)
}
```

问题：go是如何维护cap的呢？

## 复制和追加切片(Copying and appending slices)
有时我们需要扩展切片或复制切片。

### 向切片追加元素：append
追加元素到切片，可以使用以下函数：
```
func append(s[]T, x ...T) []T
```
append会自动扩展切片的容量和长度。


* 追加元素列表

```
sl3 := []int{1,2,3}
sl3 = append(sl3, 4, 5, 6)
```

* 追加另一个切片

追加另一个切片时，需要使用以下表达式来进行：

```
x = append(x, y...)
```
注意切片y后面的...符号。 

举例：
```
func doAppend() {
	s2 := []string{"hello", "world", "and", "you"}
	s4 := []string{"and", "me"}
	s2 = append(s2, s4...)
	printStringSlice(s2) // 输出: hello world and you and me
}
```

注意：append虽然很好用，但其中的扩容过程，有系统来决定的，若希望能完全控制整个扩容过程，可以按一下方式实现：

```
func AppendByte(slice []byte, data ...byte) []byte {
	m := len(slice)
	n := m + len(data)
	if n > cap(slice) { // 需要扩容 
		// 按2倍容量的增长进行扩容
		newSlice := make([]byte, (n+1)*2)
		copy(newSlice, slice)
		slice = newSlice
	}
	slice = slice[0:n]
	copy(slice[m:n], data)
	return slice
}
```

### 切片复制

切片的复制，可以使用copy()函数来实现。

```
func copy(dst, src []T) int
```

函数copy将T类型的切片元素从源src复制到目标dst，覆盖dst中的相应元素，并返回复制元素的数量。 来源和目的地可能会重叠。 复制的参数数量是len（src）和len（dst）的最小值。 当src是一个字符串时，元素类型是字节。 如果你想继续使用变量src，在复制后输入：src = dst。

* 例子 
```
func doCopy() {
	slice1 := []int{1, 2, 3}
	slice2 := make([]int, 2) 
	copy(slice2, slice1) // 复制的个数取两种长度最小的，这里是1
	fmt.Println(slice1, slice2) // 输出: [1 2 3] [1 2]
}
```

### append和copy实战例子

* 向切片中的第i个位置添加一个切片

```
func doInsert(dst []string, src []string, index int) (s []string) {
	//	suf := dst[index:]   //这样做是错误的，想想为什么？
	suf := make([]string, len(dst[index:]))
	copy(suf, dst[index:])
	result := dst[:index]
	result = append(result, src...)
	result = append(result, suf...)
	return result
}

func main() {
	s2 := []string{"hello", "world", "and", "you"}
	s4 := []string{"or", "me"}
	s3 := doInsert(s2, s4, 2)
	fmt.Println(s3)  // [hello world or me and you]
```
解读：由于切片是引用类型，若是使用
```
suf := dst[index:]
```
来获取前半段时，其实只是获取了index的位置的指针。当append的时候，会用新的值覆盖原来的位置，所以再次添加时，得到的值将是新的值。所以，这里必须使用copy，而且要make一个切片。否则以上例子就会得到以下错误的结果：

```
[hello world or me or me]
```


## strings、arrays和slices的使用

### 通过string创建bytes切片
若s是一个string，可以容易的通过以下方式创建一个bytes的切片。
```
c:=[]byte(s) 
```
原因是：本质上string就是byte的数组。


也可以使用copy的方式来创建：
```
copy(dst []byte, src string)
```

使用例子:
```
// 测试把string转换成byte切片
func String2Slice() {
	var s string = "this is a string"
	c := []byte(s)
	fmt.Println(c) // 输出：[116 104 105 115 32 105 115 32 97 32 115 116 114 105 110 103]
}
```

### 添加string到一个切片中

可以通过以下方式把string添加到一个切片中：
```
var b []byte
var s string
b = append(b, s...)  //注意这里的参数格式
```

### 构建一个子字符串
可以通过切片的方式来截取一个字符串的子字符串：

```
substr := str[start:end] 
```
注意：start最小访问的索引值为0，end的最大访问值是len(str)-1


### string和slice的内存表示

![](/assets/StringAndSlice.png)
在Go中一个string由两个字段来进行描述：
[ptr|len]
如上图所示。

### 修改字符串的值

可以通过切片操作来进行字符串的修改：
```
s:="hello"
c:=[]byte(s)
c[0]="c"
s2:= string(c)  // s2 == “cello”
```
注意：必须要把字符串转换成byte切片才能进行修改，而原来的字符串不会改变。


### 对切片和数组进行搜索和排序

标准库提供一个包来专门进行排序:sort，提供的排序函数如下：
```
func Ints(a []int)
func Float64s(a []float64)
func Strings(a []string)
```

* 对int,float,string切片进行排序

```
import (
	"fmt"
	"sort"
)

func doSort() {
	vi := []int{2, 3, 6, 1, 7}
	vf := []float64{1.0, 5.0, 3.0, 2.1}
	vs := []string{"hello", "and", "world"}

	sort.Ints(vi)
	sort.Float64s(vf)
	sort.Strings(vs)

	fmt.Println(vi)
	fmt.Println(vf)
	fmt.Println(vs)

}

func main() {
	doSort()
}
```

以上程序的输出如下：
```
[1 2 3 6 7]
[1 2.1 3 5]
[and hello world]
```

可见已经排好序了。


### 类似的append操作

Go提供了灵活的append操作，可以有多种形式，如下：

* 把切片b追加到切片a
```
a = append(a, b...)
```

* 复制切片a到一个新的切片b
```
b = make([]T, len(a))
copy(b, a)
```

* 删除索引i的元素
```
a = append(a[:i], a[i+1:]...)
```

* 截取从i到j的值
```
a = append(a[:i], a[j:]...)
```

* 使用一个新的长度为j的切片来扩展切片a
```
a = append(a, make([]T, j)...)
```

* 在索引i处插入一个元素
```
a = append(a[:i], append([]T{x},a[i:]...)...)
```

* 在索引i处插入一个新的长度为j的切片
```
a = append(a[:i], append(make([]T, j), a[i:]...)...)
```

* 在索引i处插入一个存在的切片b
```
a = append(a[:i], append(b, a[i:]...)...)
```

* 从栈中获取一个元素
```
x, a = a[len(a)-1], a[:len(a)-1]
```

* 向栈中push一个元素x
```
a = append(a, x)
```


### 切片和垃圾回收
有时候切片可能指向一个很大的数组，这样可能会占用很大的内存。但我们其实只需要数据的一小部分。
此时可以把不需要的数据过滤掉，把剩下的数据复制到一个新的切片中。
例如，如下示例代码：
```
func FindDigits(filename string) []byte {
	b, _ := ioutil.ReadFile(filename)
	b = digitRegexp.Find(b)
	c := make([]byte, len(b))
	copy(c, b)
	return c
}
```


## 可以供参考的代码

[slices](http://github.com/feyeleanor/slices)
[chain](http://github.com/feyeleanor/chain)
[lists](http://github.com/feyeleanor/lists)
