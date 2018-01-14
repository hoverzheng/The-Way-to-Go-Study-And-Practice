# Go高级编程--Goroutines and Channels

通过goroutines和channels可以实现应用程序之间的通讯和并发编程(concurrent programming)。

不要通过共享内存来进行通信，而是通过通信来实现共享内存。
注：Go的作者对自己如此自信，但个人觉得shared memory有它自己的用途。是其他任何语言都无法代替的，虽然对于共享内存需要一定的同步，但只要实现得当，完全可以无锁编程。


## Concurrency, parallelism and goroutines(并发，并行和goroutines)

### 什么是goroutines
应用程序的进程运行在一台主机上，进程是由一个或多个线程组成，多个线程之间共享进程的栈内存。

几乎所有真正的程序都是多线程的，以免引入用户或计算机的等待时间，或者能够同时处理多个请求（如Web服务器），或者提高性能和吞吐量（例如通过并行执行代码 不同的数据集）。 这种并发应用程序可以使用多个线程在1个处理器或核上执行，但只有当相同的应用程序进程在多个核心或处理器上相同时间点执行时，才真正称为并行化(parallelized)。

并行性是通过使用多个处理器使得事情快速运行的能力。 所以并发程序可能并不并行化。

众所周知，多线程应用程序难以正确对待，主要问题是内存中的共享数据，这些数据可能会以不可预测的方式被不同的线程操纵，从而导致有时无法重现的随机结果（称为竞争条件）。解决办法是通过加锁的方式一次只有一个线程能够访问数据，但这种经典的方法导致，程序的复杂度增加和性能下降。也不是现代多核和多处理器的编程方式。

在Go中，通过消息传递的方式来解决这个问题。
在Go中并行执行的实体被称为：goroutines，他们是高效的并行运行的执行单元。goroutines和系统级别的线程没有一一对应的关系：一个goroutine根据它们的可用性被映射到一个或多个线程（多路复用，执行） 这是由Go运行时的goroutine调度程序完成的。

Goroutines运行在相同的地址空间，所以访问共享内存必须同步; 这可以通过同步软件包来完成，但并不鼓励这样做：在Go中使用channels来同步goroutines。

单个一个goroutine被阻塞（比如：等待I/O完成），其他的goroutine会继续在其他线程中运行。Go的这种设计，隐藏了线程管理和创建的复杂性。

Goroutines是轻量级的，它们比线程更轻。它们占用很少的资源，它们在创建时只有4k的栈空间。栈空间的管理是自动的，若需要会动态增加或减少栈空间。另外，栈不会被(garbage collector)垃圾回收器管理，若goroutine退出栈空间也会被释放。


Goroutines可以运行在多个操作系统线程中，但是关键的是，它们**也可以在线程中运行**，让您以相对较小的内存占用来处理大量的任务。 Goroutines有操作系统线程上的时间片，因此你可以通过少量的系统线程提供任意数量的goroutines。Go运行时知道何时阻塞，何时不阻塞。

存在两种并发风格：确定性（定义明确的排序）和非确定性（锁定/互斥但未定义的顺序）。 Go的goroutines和渠道促进了确定性并发（例如，有一个发送者，一个接收者的channels），这样更加合理。 我们将在后面比较两种常用算法（Worker-problem）中的方法。

一个goroutine被实现为一个函数或方法（这也可以是一个匿名函数或lambda函数），并用关键字go调用（调用）。 这会启动与当前计算并行运行的函数，但在相同的地址空间和自己的堆栈中运行，例如：

```
go sum（bigArray）//在后台计算总和
```

goroutine的堆栈根据需要增长和缩小，而堆栈溢出是不可能的; 程序员不需要关心堆栈大小。 当goroutine完成时，它自动退出：不会给启动它的函数返回任何值。

每个Go程序必须具备的main()函数也可以看作是一个goroutine，尽管它并不是以go开头的。 Goroutines可能在程序初始化期间运行（在init（）函数中）。

当1个goroutine是例如 在处理器密集型处理器中，你可以调用r untime.Gosched（）在你的计算循环中周期性的放弃处理器，允许其他的goroutine运行; 它不暂停当前的goroutine，所以执行自动恢复。 使用Gosched（）计算分布更均匀，通信不会饿死。


### concurrency和parallelism的区别

Go的并发原语(程序能够独立执行的表达式)；所以Go的重点并不在并行性上：并发程序可能并不平行。 并行性是通过使用多个处理器使得事情快速运行的能力。 但事实证明，经过精心设计的并发程序也具有出色的并行执行能力。

在2012年1月的版本中，默认并不是并行的：不管启动了多少个goroutine，一个时间点只有一个处理器用于Go程序的执行，所以：一次只运行一个goroutine。
要让goroutines实现正真的并行，必须使用变量GOMAXPROCS。该变量告诉运行时可以同时执行多少个goroutines。
也只有gc编译器才有真正的goroutine实现，将它们映射到适当的OS线程上。 使用gccgo编译器，将为每个goroutine创建一个操作系统线程。



### 使用GOMAXPROCS
在编译的时候必须设置变量GOMAXPROCS，这样允许运行的时候多于一个线程支持。当GOMAXPROCS大于1时，

下面是一些其他的实验观察结果：当GOMAXPROCS增加到9时，1CPU笔记本电脑的性能得到了提高。在32核心机器上，GOMAXPROCS = 8达到了最佳性能，而更高的数字并没有提高该性能指标的性能。非常大的GOMAXPROCS值只会稍微降低性能; 对于GOMAXPROCS = 100，使用“H”选项“top”只显示7个活动线程。

GOMAXPROCS等于（并发）线程的数量，在具有多于1个内核的机器上，多个线程可以并行运行。


### 如何通过命令行设置GOMAXPROCS

可以在main()函数中使用以下代码片段：

```
var numCores = flag.Int(“n”, 2, “number of CPU cores to use”)
flag.Parse()
runtime.GOMAXPROCS(*numCores)
```

### goroutine的简单例子

```
// doGoroutine1
package main

import (
	"fmt"
	"time"
)

func main() {
	fmt.Println("In main()")
	go longWait()
	go shortWait()
	fmt.Println("About to sleep in main()")
	// sleep works with a Duration in nanoseconds (ns) !
	time.Sleep(10 * 1e9) 
	fmt.Println("At the end of main()")
}

func longWait() {
	fmt.Println("Beginning longWait()")
	time.Sleep(5 * 1e9) // sleep for 5 seconds
	fmt.Println("End of longWait()")
}

func shortWait() {
	fmt.Println("Beginning shortWait()")
	time.Sleep(2 * 1e9) // sleep for 2 seconds
	fmt.Println("End of shortWait()")
}
```

注意：
* 在main()函数中使用time.Sleep(10 * 1e9) 这一句是为了让main()函数等待goroutine执行完成，否则当主线程执行完成后goroutine将会退出。
* goroutine是独立的执行单位，当他们开始一个个执行时，你不能依赖什么时候开始执行goroutine，代码逻辑不能依赖goroutines的启动顺序。


### Goroutines和coroutines(Goroutines和协程)

其他语言如C＃，Lua和Python有一个协程的概念。 这个名字表示与goroutines有相似之处，但有两点不同：

* goroutines意味着并行性（或者可以并行部署），一般的协程不会
* goroutines通过渠道进行沟通; 协程通过产量和恢复进行沟通操作

Goroutines比Coroutines功能强大得多，并且很容易将协程逻辑移植到goutoutines。


## goroutines之间的通信：channels

### 基本概念

上一节的例子中的goroutine之间没有相互通信。为了完成更加复杂的工作，goroutine之间必须要相互通信：接收和发送信息，并对这些操作进行协调。
goroutine可以通过共享内存来进行通信，但不鼓励这样做，因为这样会面临所有多线程同步的问题。

在Go中，使用channel完成goroutine之间的通信。channel就像是管道(pipe)，通过它可以保证数据访问是同步的，这样可以避免使用共享内存的很多问题。
数据通过channel进行传递，而且在任何时候只有一个goroutine能够访问该数据，这样就保证了不会出现竞争条件。
数据的读写权限也可以被传递。

一个有用的比喻是比较工厂中的传送带的通道。 一台机器（制造商goroutine）把物品放在皮带上，另一台机器（消费者的goroutine）把它们拿走进行包装。

使用Channel有双重目的：交换数据并同步(保证两个执行的goroutines)在任何时候都处于已知状态。


### channel的声明和要点

```
var identifier chan datatype
```
channel是引用类型，初始化的时候是nil值。

channel有以下要点：

* 一个channel只能传输一个类型的数据单元，例如：chan int 或 chan string。
* 所有类型都可以在一个通道中使用，也可以是空接口{}，或channel的channel。
* 一个channel是一个类型化的消息队列：可以通过它传输数据。
* 它是先进先出（FIFO）的，保留了发送到它们中的单元的顺序。
* channel是双向的。
* channel是引用类型，所以我们必须使用make()函数来为它分配内存。

下面是一个创建channel的例子：

```
var ch1 chan string
ch1 = make(chan string)
```

或者这样创建：

```
ch1 := make(chan string)
```

* 创建一个int的channel的channel

```
chanOfChans := make(chan chan int)
```

* 创建一个函数的channel

```
funcChan := chan func()
```

所以channel是第一类对象：它们可以存储在变量中，可以作为参数传递给函数，可以从函数返回，而且可以通过通道发送。 此外，他们是类型相关的，允许类型系统捕获编程错误，例如：尝试通过整数通道发送指针。


### 通信操作符号: <-

该操作符非常直观地表示了数据的传输：数据沿着箭头的方向流动。

* 通过channel发送数据

```
ch <- int1
```
意思是：变量int1通过channel: ch发送（二元运算符，中缀=发送）


* 从channel中接收数据

```
int2 = <- ch 
```
意思是：变量int2从通道ch（一元前缀运算符，prefix = receive）接收数据（得到一个新的值）。
这里假设int2已经被声明，如果不是，可以写成：
```
int2：= < - ch
```

* 接收并丢弃channel中的数据

```
<-ch
```

可以用来从通道中取（下一个）值，这个值被丢弃，但是可以被测试，所以下面是合法的代码：

```
if <-ch != 1000 {
	…
}
```

相同的操作符: <- ，可以用于接收和发送，但Go依靠操作来决定做什么。虽然没有必要，但为了便于阅读，通道名称通常以ch开头或包含"chan"。
channel的发送和接收操作是原子的：它们总是完成而不会中断。

下面的示例代码说明了channel操作符的使用

```
package main

import (
	"fmt"
	"time"
)

// 创建channel，并把channel作为参数传递给goroutine的函数
func main() {
	ch := make(chan string)

	go sendData(ch)
	go getData(ch)
	time.Sleep(1e9) // 注意：若把这一行注释掉，程序会直接退出，因为主线程退出了。
}

// 向channel发送数据，若channel的读数据方没有准备好，会阻塞
func sendData(ch chan string) {
	ch <- "Washington"
	ch <- "Tripoli"
	ch <- "London"
	ch <- "Beijing"
	ch <- "Tokio"
}

// 接收channel的数据，并打印出来
func getData(ch chan string) {
	var input string
	for {
		input = <-ch
		fmt.Printf("%s ", input)
	}
}

```

若我们把go语句去掉，此时会发生以下错误：

```
---- Error run E:/Go/GoBoek/code examples/chapter 14/goroutine2.exe with
code Crashed  ---- Program exited with code -2147483645: panic: all goroutines are
asleep—deadlock!
```

为什么会发生这样的错误呢？按错误的提示，发生了死锁。channel正在相互等待读取或发送数据，这样就发生了死锁。
死锁能够被程序检测到。

注意：不要通过打印channel的顺序来判断channel中数据的顺序，因为有可能该顺序是不正确的。


### 阻塞channel

默认情况下基于channel的通信是同步的，而且是unbuffered的。所以必须要对方准备好了，才能进行发送或接受：

* 发送操作将会阻塞，直到接收端准备好了。
* 接收操作将会阻塞，直到发送端准备好了。也就是说：若channel中没有数据，接收者将会阻塞。

下面是一个channel接受与发送的例子：

```
package main

import "fmt"

func main() {
	ch1 := make(chan int)
	go pump(ch1) // pump hangs
	fmt.Println(<-ch1) // prints only 0
}

func pump(ch chan int) {
	for i := 0; ; i++ {
		ch <- i
	}
}
```

输出：
```
0
```

分析：该程序的main函数中，只是输出了0，因为main函数中使用了<-ch1来读取channel中的数据。但一次只读取其中的一个数据单元。所以读取完0后，main线程退出，其他goroutine也随之退出。


* 我们可以修改一下上面的程序：

```
package main

import "fmt"

func main() {
	ch1 := make(chan int)
	go pump(ch1) // pump hangs
	for i := 0; i < 100; i++ { // 只打印channel中的100值
		fmt.Println(<-ch1)
	}
}
func pump(ch chan int) {
	for i := 0; ; i++ {
		ch <- i
	}
}

```

这一次将输出0~99个数值。
当然，我们可以使用另一个goroutine来接收channel中的数据。

```
package main

import (
	"fmt"
	"time"
)

func main() {
	ch1 := make(chan int)
	go pump(ch1) // pump hangs
	go suck(ch1)
	time.Sleep(1e9)
}
func pump(ch chan int) {
	for i := 0; ; i++ {
		ch <- i
	}
}

func suck(ch chan int) {
	for {
		fmt.Println(<-ch)
	}
}

```

程序分析：以上代码goroutine： suck会不断从channel中取数据，并打印。知道main的sleep时间到期而退出。


### 通过channel的数据交换来实现同步

通信是一种同步形式：两个goroutine通过channel的数据交换来实现信息通信的同步。无缓冲的通道是同步多个goroutine的非常好的工具。
有可能chennel的两端相互等待对方，而造成死锁。go在运行时会检测到这种情况，并停止程序的运行。
死锁的产生往往是由于不好的设计导致的。

我们知道，在无缓冲的channel上的操作可能会阻塞，避免这种情况发生的方法是：很好的设计程序或使用缓冲区channel，

* 对死锁的分析

请查看一下程序，分析其结果。
```
package main

import (
	"fmt"
)

func f1(in chan int) {
	fmt.Println(<-in)
}
func main() {
	out := make(chan int)
	out <- 2
	go f1(out)
}

```

通过分析和运行我们得到以下的错误输出：
```
fatal error: all goroutines are asleep - deadlock!
```

分析产生这种错误的原因，有利于我们对死锁的理解。

```
out := make(chan int)
out <- 2 //执行这一句时，接收端还没有准备好，此时main线程阻塞了
```
注意：执行以上两句话时，main线程阻塞，此时不会再往下执行了。由于没有其他goroutine在接收，直接报错。
所以以上程序的 go f1(out) 这一句是不会执行的，注释掉也会报同样的错误。

那么，如何修改呢？如何：

```
package main

import (
	"fmt"
)

func f1(in chan int) {
	fmt.Println(<-in)
}
func main() {
	out := make(chan int)
	go f1(out)
	out <- 2
	fmt.Print("here")
}
```
就是把接收端的goroutine放在前面，而发送端放到后面。此时接收端会一直阻塞，直到发送端发送数据。


### 异步channel--带buffer的channel

没有buffer的channel中只能包含一个元素，我们可以定义一个有buffer的channel。

```
buf := 100
ch1 := make(chan string, buf)
```
这里的buf是channel中能够容纳的元素个数。

向带缓冲区的channel发送数据时不会阻塞，直到channel的缓冲区满了。读也不会阻塞，直到缓冲区空了。

如果容量大于0，则通道是异步的：如果缓冲区未满（发送）或未空（接收），则通信操作成功而不会阻塞，并且元素以发送顺序接收。 如果容量为零或不存在，则只有当发送者和接收者都准备好时，通信才能成功。

使用带缓冲区的channel更加灵活和富有弹性，但首先要使用无缓冲区的channel来设计你的算法。

### 使用channel输出结果

可以通过一个goroutine来计算数组的结果，并通过channel来接收结果，从而得之计算已经完成。

这样的功能可以通过以下程序得以实现：
```
package main

import (
	"fmt"
)

func f1(in chan int) {
	fmt.Println(<-in)
}

func sum(arr []int, ch1 chan int) {
	var sum int = 0
	for v := range arr {
		sum += v
	}
	ch1 <- sum
}

func main() {
	ch1 := make(chan int)
	arr := []int{1, 2, 3, 4, 5, 6}
	go sum(arr, ch1)
	result := <-ch1

	fmt.Printf("result=%d\n", result)
}
```

通过goroutine和channel我们可以把一个大的任务分解成多个小的任务分别到一个goroutine去完成，然后再由一个goroutine进行结果汇总。
通过这两个组件非常好实现。


### 信号量模式(Semaphore pattern)

* 通过goroutine返回来通知完成

下面的代码中，goroutine通过在channel中输入一个值来表示它的完成，main线程在<-ch上等待，直到接收到channel中的数据值。

```
func compute(ch chan int) {
 	//当someComputation()函数完成后，把结果发送到channel中，
 	// 而此时主线程阻塞在channel中等待该结果，这样相当于给主线程发送了一个完成的信号
	ch <- someComputation() 
}

func main() {
	ch := make(chan int) // allocate a channel.
	go compute(ch) // start something in a goroutine
	doSomethingElseForAWhile()

	// 阻塞，直到channel中的数据发送过来
	result := <-ch
}
```

* 通过常量值来完成通知

```

ch := make(chan int)

go func() {
	// doSomething
	ch <- 1 // 发送一个信号，并不关心其值是什么
}()

doSomethingElseForAWhile()
<-ch  //  等待goroutine执行结束，丢弃channnel中的
```

* 等待两个goroutine的结束

```
done := make(chan bool)

// doSort is a lambda function, so a closure which knows the channel done:
doSort := func(s []int) {
	sort(s)
	done <- true
}

i := pivot(s)
go doSort(s[:i])
go doSort(s[i:])

<-done
<-done
```

* 等待n个goroutine执行完成

在下面的代码片段中，我们有一个完整的信号量模式，其中N个计算doSomething（）在一个具有该大小的float64的片段上并行完成，并且具有完全相同长度的通道sem（并且包含类型为空的接口项 ）在每个计算完成时发出信号（通过在其上放置一个值）。 要等所有的goroutine完成，只需在频道sem上建立一个接收范围循环：

下面的代码片段中，遍历整个data数据集，并对每个数据单元启动一个goroutine来进行处理。那么如何得知每个goroutine已经处理完成了呢？
思路很简单：就是每个goroutine完成后都会向channel中发送一个空的数据，这样想要知道goroutine是否完成的线程，只需要阻塞在该channel上，即可。
代码片段如下：

```
type Empty interface {}
var empty Empty
...

data := make([]float64, N)
res := make([]float64, N)
sem := make(chan Empty, N)  // semaphore
...

for i, xi := range data {
	go func (i int, xi float64) {
		res[i] = doSomething(i,xi)
		sem <- empty
	} (i, xi)
}

// wait for goroutines to finish
// 等待每个goroutine结束，不关心顺序
for i := 0; i < N; i++ { <-sem }
```

请注意使用闭包：将当前的i，xi作为参数传递给闭包，从外部for循环中屏蔽掉i，xi变量。 这允许每个goroutine拥有自己的i，xi; 否则，for循环的下一次迭代将更新所有goroutine中的i，xi。 另一方面，res分片不会传递给闭包，因为每个goroutine都不需要它的单独副本。 res分片是闭包环境的一部分，但不是一个参数。


### 实现并行for循环

要实现for循环的并行化，必须要for中的每个计算过程都独立运行，这样可以带来很大的性能提升。在go中很容易实现for循环的并行处理。
可以按以下代码形式进行：

```
for i, v := range data {
	go func (i int, v float64) {
		doSomething(i, v)
		…
	} (i, v)
}
```


### 使用带缓冲区的channel实现信号量

信号量是非常常用的同步机制，可以用来实现互斥锁，多个资源的互斥访问，解决reader-writer的问题。在Go中没有实现原子量，但可以通过channel来实现。通过channel来实现，基于以下事实：

* buffered channel的容量大小是我们希望同步的资源数
* channel目前的长度，是目前的可用资源数
* channel的容量减去channel目前的长度，是释放的资源数

我们并不关心channel中的值，仅关心channel的长度。因此，我们可以先定义一个长度为0的空channel。

```
type Empty interface {}
type semaphore chan Empty
```

现在我们创建一个有N个元素的channel：

```
sem = make(semaphore, N)
```

下面我们就可以来设计我们的同步操作了：

```
// acquire n resources
func (s semaphore) P(n int) {
	e := new(Empty)
	for i := 0; i < n; i++ {
		s <- e
	}
}

// release n resources
func (s semaphore) V(n int) {
	for i := 0; i < n; i++ {
		<-s
	}
}
```


* 实现互斥锁

```
/* mutexes */
func (s semaphore) Lock() {
	s.P(1)
}

func (s semaphore) Unlock() {
	s.V(1)
}

```

* 实现信号量

```
/* signal-wait */
func (s semaphore) Wait(n int) {
	s.P(n)
}

func (s semaphore) Signal() {
	s.V(1)
}
```


