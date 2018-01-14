# 接口和反射(Interfaces and reflection)

##  基本概念
Go不是常规的OO（面向对象的）语言，它没有继承和类的概念。
但它提供了**interface(接口)**，在Go中，接口提供了类似于对象的行为：若一个东西做到了接口的约定，它就可以在这里使用。

一个接口，定义了一组**没有实现代码的函数（因为他们是抽象的）**，同时接口也**不能包含变量**。

接口的声明如下：

```
type Namer interface {
	Method1(param_list) return_type
	Method2(param_list) return_type
	…
}
```

这里的Namer就是一个接口类型。

* 接口的命名规则
接口名通常由方法名加上[e]r后缀组成，例如：Printer, Reader, Writer, Logger, Converter等等。
有些名字添加er是不合适的，这样会添加able，例如：Recoverable。
或则以它自己的名字开始，例如：.NET或Java。


与大多数OO语言不同，Go接口中可以包含值，接口类型的变量或接口值：var ai Namer ai是一个未初始化的值为nil的多field的结构类型变量。虽然不是完全相同的东西，但它本质上是一个指针。 所以指向接口值的指针是非法的。 他们将是完全无用的，并导致在代码中的错误。


类型（比如struct）可以实现接口的方法集，该实现包含了：每个方法的实际代码如何使用该类型的变量。
这也就是：接口的实现，方法集构成了该类型的接口。

每个方法的实际代码如何作用于该类型的变量：它们实现接口，方法集合构成该类型的接口。
每个实现接口的类型的变量，都可以被分配给ai（接收器值），然后方法表具有指向实现的接口方法的指针。
当另一种类型的变量（也实现该接口）被分配给ai时，这两者当然会改变。也就是说指向了该实现的方法体。

对于接口要注意一下几点：

* 一个类型不必明确声明它实现了一个接口：接口是隐式满足的。多种类型可以实现相同的接口。
* 实现接口的类型也可以有其他的功能。
* 一个类型可以实现多个接口。
* 接口类型可以包含对实现接口的任何类型的实例的引用（接口具有所谓的动态类型）
* 一个类型若是实现了接口，就需要实现该接口的所有方法。？？

即使接口定义的时间晚于类型，在不同的包中，也要单独编译：如果对象实现了接口中指定的方法，则说明它实现接口。



使用接口的例子：

```
package main

import (
	"fmt"
	"math"
)

type Shaper interface {  // 定义了一个接口
	Area() float32
}

type Square struct { 	// 定义了一个struct类型
	side float32
}

func (sq *Square) Area() float32 {  // struct类型实现了接口Shaper，注意接口实现的写法
	return sq.side * sq.side
}

type Circle struct {
	r float64
}

func (sq *Circle) Area() float32 {
	v := math.Pi * math.Sqrt(sq.r)
	return float32(v)
}

func main() {
	sq1 := new(Square)
	sq1.side = 5

	/*
	 * 这里省略掉了areaIntf的声明，可以这样写，可能更加清楚一些：
	 *  // var areaIntf Shaper
	 *	// areaIntf = sq1
	 */
	areaIntf := sq1
	fmt.Printf("The square has area: %f\n", areaIntf.Area())


	sq2 := new(Circle)
	sq2.r = 2.0
	areaIntf2 := sq2
	fmt.Printf("The circle has ares: %f \n", areaIntf2.Area())

	// 或则这样遍历
	shapes := []Shaper{sq1, sq2}
	for n, _ := range shapes {
		fmt.Println("Shape details: ", shapes[n])
		fmt.Println("Area of this shape is: ", shapes[n].Area())
	}
}

```

在main()中构造了Square的一个实例。 main()之外，我们有一个接收器类型为Square的Area()方法来计算正方形的面积：struct Square实现接口Shaper。

这样，我们可以将Square类型的变量分配给接口类型的变量：
```
areaIntf = sq1
```

现在接口变量areaIntf包含了对Square变量的引用，通过它我们可以调用Square上的方法Area()。 当然，你可以立即在Square实例sq1.Area()上调用方法，但是具有创新性的是我们可以在接口实例上调用它，从而泛化了调用。接口变量包含接收者实例的值和一个指向方法表中适当方法的指针。

这就是Go版本**多态**的实现，OO软件中一个众所周知的概念：**根据当前类型选择正确的方法，或者换句话说：一个类型在链接到不同的实例时似乎表现出不同的行为。**

如果Square不具有Area（）的实现，我们将收到非常明确的编译器错误：

```
cannot use sq1 (type *Square) as type Shaper in assignment:
*Square does not implement Shaper (missing Area method)
```

注意：若Shaper接口还有另外一个方法：Perimeter()，但Square没有实现它，也会报同样的错误。


* 基于指针还是基于值来实现接口

下面还有一个接口的例子：
```
// doInterface2
package main

import (
	"fmt"
)

type Shaper interface {
	Area() float32
}

type Square struct {
	side float32
}

func (sq *Square) Area() float32 { //注意这里是指针
	return sq.side * sq.side
}

type Rectangle struct {
	length, width float32
}

func (r Rectangle) Area() float32 { // 这里是值
	return r.length * r.width
}

func main() {
	r := Rectangle{5, 3} // Rectangle的Area()需要一个值
	q := &Square{5}      // Square的Area()需要一个指针
	// shapes := []Shaper{Shaper(r), Shaper(q)}
	// or shorter:
	shapes := []Shaper{r, q}
	fmt.Println("Looping through shapes for area ...")
	for n, _ := range shapes {
		fmt.Println("Shape details: ", shapes[n])
		fmt.Println("Area of this shape is: ", shapes[n].Area())
	}
}
```

输出如下：
```
Looping through shapes for area ...
Shape details:  {5 3}
Area of this shape is:  15
Shape details:  &{5}
Area of this shape is:  25
```

通过以上例子我们可以得出：

* 可以基于struct类型的值或指针来实现接口
```
func (sq *Square) Area() float32 //基于struct的指针实现接口
func (r Rectangle) Area() float32  //基于struct的值来实现接口
```

* 若实现接口时使用的是值，使用时也必须使用值
```
r := Rectangle{5, 3}
```

* 若实现接口是使用的是指针，使用时也必须使用指针
```
q := &Square{5}
```

这样通过接口调用时，就可以按如下方式实现多态：
```
shapes := []Shaper{Shaper(r), Shaper(q)}
shapes[n].Area()
```
