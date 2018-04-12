
# Go-函数和方法

## 3中类型的函数

* 一般的函数
* 匿名或lambda(Anonymous or lambda)函数
* 方法(Methods)

以上3种函数都可以有参数和返回值。

## 函数的定义和使用

### 函数的定义

在Go中函数的定义形式如下：
```
func g() {  // 正确

}
```

而下面的定义形式是错误的：
```
func g()
{  // 错误

}
```

### 函数的调用

函数的调用形式如下：

```
pack1.Function(arg1,arg2, . . . ,argn)
```


### 在函数中调用其他函数

和其他语言一样：

```
package main

func main() {
	println("In main before calling greeting")
	greeting()
	println("In main after calling greeting")
}

func greeting() {
	println("In greeting: Hi!!!!!")
}

```

### 把函数作为参数

可以把函数作为参数传递给其他函数：

```
func f1(a, b int) (int, int, int) {
	
}


func f2(a, b, c int) {
	
}

```

以上定义了两个函数，在使用函数时可以这样调用：

```
f1(f2(a,b))
```

### 关于函数重载

在Go中不支持函数的重载，也就是说同一个包中相同函数名的函数不允许有两个。


### 函数作为类型值

可以把函数作为一种函数类型的值，可以把该值赋给一个变量。


注意：在函数中不能申明函数，但可以使用匿名函数。


## 函数的参数和返回值

函数可以接收一个或多个参数，可以返回一个或多个值。若是返回多个值，则是以tuple的形式返回。

测试一个函数是否执行正确有特殊的方法，在后面进行讲解。(todo:)

一个函数必须返回一个值，或者是产生panic错误。


### 传参数值还是传参数的引用(指针)

默认情况下Go的函数是传值，当然你可以传递参数的地址(指针)。

通过值传递时，函数不会改变参数的值（和其他语言一样），当传递变量的指针时，就可以改变指针指向的变量的内容。

```
Function(arg1)  //传值
Function(&arg1) /传指针
```

另外一下类型的变量，默认情况下是传指针：

* slices
* map
* interfaces
* channels


### 返回值

有些函数完成任务后，并没有返回任何值。但有些函数会返回一些值，这些值可能是以变量的形式返回的，也可能不是以变量的方式返回。
例如下面的例子：

```
package main

import "fmt"

func main() {
	fmt.Printf("Multiply 2 * 5 * 6 = %d\n", MultiPly3Nums(2, 5, 6))
	// var i1 int = MultiPly3Nums(2, 5, 6)
	// fmt.Printf("Multiply 2 * 5 * 6 = %d\n", i1)
}
func MultiPly3Nums(a int, b int, c int) int {
	// var product int = a * b * c
	// return product    			// 可以通过变量的方式返回
	return a * b * c 				// 也可以通过匿名变量的方式返回
}

```




