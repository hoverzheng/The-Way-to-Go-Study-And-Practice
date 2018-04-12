# 结构和方法（Structs and Methods）

当你想要定义一个由许多属性组成的类型时可以使用struct(结构)。结构是复合类型，每个属性都有自己的类型和值。
那么可以像访问单个实体一样访问这些数据。
他们也是一种值类型，所以可以使用new函数来进行创建。

构成结构类型的组件数据片段称为字段。 一个字段有一个类型和一个名字; 结构中的字段名称必须是唯一的。

但是因为Go没有类的概念，所以在Go中struct(结构)类型更重要。

## 定义struct

### 创建struct类型
* 第一种
一般的struct的定义格式如下：

```
type identifier struct {
	field1 type1
	field2 type2
	…
}
```

* 第二种

```
 type T struct { a, b int }
```
这样就可以使用T来定义变量了。

若在代码中，有一个field从来都没有被使用，可以命名为_

结构中的field可以是任意类型的值，比如：struct，接口，或函数。


### 定义和初始化struct类型的变量

* 通过var来声明并赋值
可以声明一个结构变量，并给他赋值：T

```
var s T
s.a = 5
s.b = 8
```

* 使用new函数

```
var t *T
t = new(T)
```
t是一个指针，指向拥有0值的T类型的实体。

* 使用var
通过var可以为T类型的变量t初始为0值。但t是一个T类型的实例，而不是指针。

```
var t T
```


### 实战：定义和使用简单的struct

```
package main

import (
	"fmt"
)

type struct1 struct {
	i1  int
	f1  float32
	str string
}

func main() {
	ms := new(struct1)
	ms.i1 = 10
	ms.f1 = 15.5
	ms.str = "Chris"
	fmt.Printf("The int is: %d\n", ms.i1)
	fmt.Printf("The float is: %f\n", ms.f1)
	fmt.Printf("The string is: %s\n", ms.str)
	fmt.Println(ms)
}
```

注意：%v可以打印整个结构体的值。


### 访问和修改field的值

* 修改field的值

可以通过以下方式来修改struct变量中，field的值：

```
structname.fieldname = value
```

* 获取field的值
```
 structname.fieldname
```

* 通过指针获取field的值
```
type myStruct struct { i int }
var p *myStruct // p is a pointer to a struct
v.i
p.i
```

* 通过struct的变量获取field的值

```
type myStruct struct { i int }
var v myStruct // v has struct type
v.i
p.i
```

可以看出，通过struct的指针变量和类型变量来访问field的值的方式都是一样的，都是通过所谓的选择运算符：.号来进行的。


```
ms := &struct1{10, 15.5, “Chris”}  // 意思是：ms是 *struct1类型的变量，也就是指针变量
或:  
var mt struct1
mt = struct1{10, 15.5, “Chris”}
```

其实，以下两个表达式是相同的：
```
new(Type)
或
&Type{}
```


* 初始化的两种类型

```
type Interval struct {
	start int
	end int
}
```

(1) 一种是按fieldname的顺序进行初始化

```
inter := Interval{0,3} 
```

(2) 一种是指定fieldname进行初始化，此时的顺序就不重要了

```
inter2 := Interval{end:3, start:0}
```

以上两种初始化得到结果是相同的。


### 传递结构的指针

可以给函数传递结构的指针，以便减少参数传递的数据量，以下三种传递结构体指针的方式都是可行的：
 
```
// doStruct2
package main

import (
	"fmt"
	"strings"
)

type Person struct {
	firstName string
	lastName  string
}

func upPerson(p *Person) {
	p.firstName = strings.ToUpper(p.firstName)
	p.lastName = strings.ToUpper(p.lastName)
}

func main() {
	// 1- struct as a value type:
	var pers1 Person
	pers1.firstName = "Chris"
	pers1.lastName = "Woodward"
	upPerson(&pers1)
	fmt.Printf("The name of the person is %s %s\n", pers1.firstName, pers1.lastName)

	// 2—struct as a pointer:
	pers2 := new(Person)
	pers2.firstName = "Chris"
	pers2.lastName = "Woodward"
	(*pers2).lastName = "Woodward" // this is also valid
	upPerson(pers2)
	fmt.Printf("The name of the person is %s %s\n", pers2.firstName, pers2.lastName)

	// 3—struct as a literal:
	pers3 := &Person{"Chris", "Woodward"}
	upPerson(pers3)
	fmt.Printf("The name of the person is %s %s\n", pers3.firstName, pers3.lastName)
}
```




## 结构体实战


### 定义一个单链表

下面定义了一个简单的单链表。操作不是很全，但演示了链表的相关操作和数据结果的设计。

```
// doLinkList
package main

import (
	"fmt"
)

type Node struct {
	data int
	next *Node
}

// 定义节点操作函数
func (LinkeList *Node) Add(n1 *Node) {
	n1.next = LinkeList.next
	LinkeList.next = n1
}

// 遍历链表
func (n *Node) Travel(head *Node) {
	for l := head; l != nil; l = l.next {
		fmt.Println(l.data)
	}
}

func main() {

	head := new(Node)
	head.data = 0
	head.next = nil

	for i := 1; i < 10; i++ {
		n2 := new(Node)
		n2.data = i
		n2.next = nil

		head.Add(n2)
	}

	head.Travel(head)
}

```


## 通过工厂方法来创建struct

```

type Person struct {
	id int
	name string
}

func NefPerson(id int, name string) *Person {
	if id < 0 {
		return nil
	}

	return &Person{id, name}
}
```


## 通过new()和make()来访问struct

```
func testStruct() {

	// map的创建和初始化
	//p1 := make(Person)   //这样写是错误的，编译不会通过，因为make只会创建和初始化slices, maps和channels

	p1 := new(Person)
	p1.id = 1
	p1.name = "hover"

	// 通过make来创建和初始化map变量
	m1 := make(myMap)
	m1["name1"] = "name1"

	// 通过new来创建map变量
	/*
	 * 注意一下写法是错误的，会产生panic的错误
	 */
	//m2 := new(myMap)
	//m2["name2"] = "name2"

	m2 := make(myMap)
	m2["name2"] = "name2"

}
```

要点总结：

* make 只是用于slices,map和channels这三种类型
* make 会对类型分配空间，并对数据进行初始化

* new会分配空间，但会把所有结构的数据都初始化成0
* 在对map数据进行创建和初始化时，最好使用make


## 为结构体的field添加tag

可以为struct的每个field添加标签，该标签在正常使用时不会用到，但在反射的时候可以获取该标签的值。

定义标签的语法如下:

```
type TagType struct {
	field1 bool "An import answer"
	field2 string "The name of the thing"
}
```


一个定义标签和使用标签的例子：

```
package main

import (
	"fmt"
	"reflect"
)

type TagType struct { // tags
	field1 bool   "An important answer"
	field2 string "The name of the thing"
	field3 int    "How much there are"
}

func main() {
	tt := TagType{true, "Barak Obama", 1}
	for i := 0; i < 3; i++ {
		refTag(tt, i)
	}
}

func refTag(tt TagType, ix int) {
	ttType := reflect.TypeOf(tt)
	ixField := ttType.Field(ix)

	fmt.Printf("%v\n", ixField.Tag)
}

```

输出：

```
An important answer
The name of the thing
How much there are
```


## 匿名field和嵌入结构体

### 匿名field的使用

所谓匿名的field，是指：只有类型没有变量名的field。该field也可以struct类型。
对于匿名field来说，类型名就是变量名。这就意味着，在一个struct中有两个相同类型的匿名field是不允许的。

这与OO语言中的继承概念有些相似，我们将会看到它可以用来模拟像继承的行为。 这是通过嵌入或组合获得的，所以我们可以说在Go组合中比继承更好用。


一个完整使用匿名field的例子如下：

```
package main

import "fmt"

type innerS struct {
	in1 int
	in2 int
}

type outerS struct {
	b      int
	c      float32
	int    // anonymous field
	innerS // anonymous field
}

func main() {
	outer := new(outerS)
	outer.b = 6
	outer.c = 7.5

	outer.int = 60
	outer.in1 = 5
	outer.in2 = 10
	fmt.Printf("outer.b is: %d\n", outer.b)
	fmt.Printf("outer.c is: %f\n", outer.c)
	fmt.Printf("outer.int is: %d\n", outer.int)
	fmt.Printf("outer.in1 is: %d\n", outer.in1)
	fmt.Printf("outer.in2 is: %d\n", outer.in2)
	// with a struct-literal:
	outer2 := outerS{6, 7.5, 60, innerS{5, 10}}
	fmt.Println("outer2 is: ", outer2)
}

```

### 嵌入structs

作为结构也是一个数据类型，它可以用作匿名字段; 看上面的例子。 outerS结构体可以直接使用outer.in1访问innerS结构体的域， 当嵌入式结构来自另一个包时，情况更是如此。 
innerS结构简单地插入或“嵌入”到outerS。 这个简单的“继承”机制提供了一种从另一个或多个类型派生出一些或全部实现的方法。

```
package main

import "fmt"

type A struct {
	ax, ay int
}

type B struct {
	A
	bx, by float32
}

func main() {
	b := B{A{1, 2}, 3.0, 4.0}
	fmt.Println(b.ax, b.ay, b.bx, b.by)   //注意：这里可以直接通过外部结构体访问内部结构体的变量
	fmt.Println(b.A)
}

```

输出：

```
1 2 3 4
{1 2}
```

* 总结：可以直接通过外部结构体访问内部结构体的变量，这有点像类的继承机制。


### field名冲突

当struct的两个field有相同的名字时，Go是有一定的处理规则，如下：

* 外部的名字变量隐藏内部的名字变量，

```
type A struct { a int }
type B struct { a, b int }

type D struct { B; b float32 }
var d D;
```

这里使用d.b是没有问题的，这里使用的是float32类型的b，也就是最上层的b。而不是结构体B中的b变量。
若想使用B的变量，可以这样写：d.B.b


* 若在相同的层次上，有相同的变量名，则编译不会通过

```
type A struct { a int }
type B struct { a, b int }

type C struct { A; B }
var c C;
```

根据以上的代码，若使用c.a，则编译不会通过。因为，编译器不知道是使用的A的a，还是B的a变量。

若非要使用a的field，需要指定结构体：
```
c.A.a
或
c.B.a
```


## 方法(Methods)

方法是一类特殊的函数。它可以类似于类的方式在一个接受者(receiver)中定义。它的一般定义形式是：

```
func (recv receiver_type) methodName(parameter_list) (return_value_list) { … }
```

和函数的唯一不同是，(recv receiver_type)的前缀，这里recv是一个指针，类型是receiver_type。

注意：receiver可以是任何类型：可以是函数，或基本类型的别名类型，比如bool,string, array等。但接口类型不能定义方法。

（结构）类型及其方法的组合是OO中类的Go等价物。 一个重要的区别是类型的代码和绑定到它的方法没有组合在一起; 它们可以存在于不同的源文件中，唯一的要求是它们必须在同一个包中。

给定类型T（或* T）上所有方法的集合被称为T（或* T）的方法集合。
方法是函数，所以，函数是没有重载的，也就是说同一个函数名不能被定义两次。但reciever是可以重载的，也就说同一个函数名，可以存在不同的reciever类型种。

形式如下：

```
func (a *denseMatrix) Add(b Matrix) Matrix
func (a *sparseMatrix) Add(b Matrix) Matrix
```

如果方法不需要使用值recv，则可以通过用_替代来放弃它，如下所示：
```
func (_ receiver_type) methodName(parameter_list) (return_value_list) { … }
```

recv就像OO语言中的this或self，但在Go中没有指定特殊的关键字;
如果你喜欢，你可以使用self或this作为接收者变量的名字，但你可以自由选择。 

下面的代码说明了如何定义和使用方法：

```
package main

import "fmt"

type TwoInts struct {
	a int
	b int
}

func main() {
	two1 := new(TwoInts)
	two1.a = 12
	two1.b = 10
	fmt.Printf("The sum is: %d\n", two1.AddThem())
	fmt.Printf("Add them to the param: %d\n", two1.AddToParam(20))
	two2 := TwoInts{3, 4}
	fmt.Printf("The sum is: %d\n", two2.AddThem())

	two2.PrintValue()
}

func (tn *TwoInts) AddThem() int {

	return tn.a + tn.b
}
func (tn *TwoInts) AddToParam(param int) int {
	return tn.a + tn.b + param
}

/*
 * 注意这样写也是可以的，但这样写不能改变接收者的值，所以最好是保持一致写成：
 * func (tn *TwoInts) PrintValue() {...}
 */
func (tn TwoInts) PrintValue() { //这样写不能改变接收者tn的值
	fmt.Println(tn.a + tn.b)
}

```

* 例子2

```
package main

import "fmt"

type IntVector []int

func (v IntVector) Sum() (s int) {
	for _, x := range v {
		s += x
	}
	return
}
func main() {
	fmt.Println(IntVector{1, 2, 3}.Sum()) // Output: 6
}

```

* 例子3

为int的别名类型添加函数：

```
type TypeInt int

func (iv *TypeInt) PrintValue() {
	fmt.Println(*iv)
}

func main() {
	var iv TypeInt = 1
	iv.PrintValue()
}
```

一个方法和它所作用的类型必须在同一个包中定义，这就是为什么你不能定义类型为int，float或类似的方法。 试图定义一个int类型的方法给编译器错误：

```
cannot define new methods on non-local type int
```

但是有一个办法：你可以为这个类型定义一个别名（int，float，...），然后为这个类型定义一个方法。 或者将类型嵌入到新结构中的匿名类型中，如下例所示。 当然这个方法只对别名类型有效。如上面的例子。

### 函数(functions)和方法(methods)的不同

1. 调用方式不同

* 函数将变量作为参数：Function1（recv）
* 方法是在变量上进行调用：recv.Method1（）

一个方法可以改变接收器变量的值（或状态），但需要接受者是一个指针，就像函数的情况一样（当一个函数作为一个指针传递时，函数也可以改变它的参数的状态：call by reference）。

！ 不要忘记Method1之后的（），否则你会得到编译器错误：方法recv.Method1不是表达式，必须调用！

接收者必须有一个明确的名字，这个名字必须在方法中使用。
receiver_type被称为（接收者）基类型，这个类型必须和其所有方法一样在同一个包中声明。

在Go中，附加到（接收者）类型的方法不会写入到结构中，就像类的情况一样; 耦合更松散：方法和类型之间的关联由接收机建立。

** 方法不与数据定义（结构）混合：它们与类型正交; 表示（数据）和行为（方法）是独立的。**


### 接受者是基于指针还是基于值

接受者可以是指针类型，也可以是值类型。

由于性能方面的原因，recv通常是指向receiver_type的指针（因为我们没有创建实例的副本，就像通过值调用的情况一样），当接收者类型是结构时尤其如此。

** 如果您需要修改接收方指向的数据的方法，请在指针类型上定义方法。** 否则，在正常值类型上定义方法通常更简洁。

这在以下示例pointer_value.go中进行了说明：change（）接收指向B的指针，并更改其内部字段; write（）只输出B变量的内容并通过复制接收它的值。 在main（）中注意到Go为我们做了管道工作，我们自己不需要弄清楚是否在指针上调用方法，Go就是为我们做的。 b1是一个值，b2是一个指针，但方法调用工作得很好。

```
package main

import (
	"fmt"
)

type B struct {
	thing int
}

func (b *B) change()      { b.thing = 1 }
func (b B) write() string { return fmt.Sprint(b) }

func main() {
	var b1 B // b1 is a value
	b1.change()
	fmt.Println(b1.write())
	b2 := new(B) // b2 is a pointer
	b2.change()
	fmt.Println(b2.write())
}

```

可以基于类型变量或类型变量的指针来定义方法，若类型T有一个方法Method()，那么对于T指针类型来说(*T).Method()也是可用的。或反过来也同样适用。

可以有附加到类型的方法，以及附加到类型指针的其他方法。
但是，这并不重要：如果对于T类型，方法Meth()存在于*T上，并且t是类型T的变量，则t.Meth()会自动转换为(&t).Meth()

指针和值方法都可以在指针或非指针值上调用，这在下面的程序中进行了说明，其中类型List的值是Len（）方法，指向List的方法是Append（），但是 我们看到这两种方法都可以在两种类型的变量上调用。

```
package main

import (
	"fmt"
)

type List []int

func (l List) Len() int        { return len(l) }
func (l *List) Append(val int) { *l = append(*l, val) }


func main() {
	// A bare value
	var lst List
	lst.Append(1)
	fmt.Printf("%v (len: %d)\n", lst, lst.Len()) // [1] (len: 1)

	// A pointer value
	plst := new(List)
	plst.Append(2)

	fmt.Printf("%v (len: %d)\n", plst, lst.Len()) // &[2] (len: 1)
}
```


### Methods and not-exported fields



## 总结

* struct有类似于类的继承机制，外层的struct可以直接引用内部struct的变量值。若内部和外部有相同的field，则外部覆盖内部field；若在相同层级上有相同的field，编译不会通过。
* 可以基于类型的值或是指针来定义方法，基于类型的方法比较简洁，但不能改变类型变量的值，需要改变类型变量的值，需要基于指针来定义方法。

