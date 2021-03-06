# Go的包概览

## 标准库概览

Go包括150个内建的标准库，比如：fmt,os等，可以在这里查看[官方的文档](http://golang.org/pkg/)。

unsafe: 在一般情况下不需要，在和C/C++程序进行交互的时候才需要。

下面介绍各种内建包的概要：


### 系统调用-os/exec

* os

为我们提供了一个平台无关的操作系统功能接口; 它的设计是类似于Unix（所以对于unix/linux程序员这些内容应该很熟悉了）; 它隐藏了各种操作系统之间的差异，以提供文件和其他操作系统对象的一致视图。

* os/exec
为您提供运行外部操作系统命令和程序的可能。

* syscall
是低层的外部包，它提供了一个基本的操作系统调用的原始接口。


例子：


* archive/tar and /zip—compress
提供解压的函数


### fmt—io—bufio—path/filepath—flag

* fmt
格式化输入输出函数。

* io
提供了基本的输入输出功能，主要作为os函数的包装。

* bufio
针对io以提供缓冲输入输出功能。

* path/filepath
用于处理所使用的操作系统的文件名路径的例程。

* flag
提供处理命令行参数的功能函数。

### strings—strconv—unicode—regexp—bytes

* string
用于处理字符串。

* strconv
将字符串转换为基本的数据类型。

* unicode
Unicode字符的特殊功能。

* regexp
正则表达式：在复杂的字符串中提供模式搜索功能。

* bytes
字节：包含用于操纵字节片段的函数。

* index/suffixarray
用于在字符串中快速搜索。


### math—math/cmath—math/big—math/rand—sort

* math
基本的数学常数和功能。

* math/cmath
用complx数字操作。

* math/rand
提供伪随机数生成器的功能。

* sort
提供数组和用户定义集合的排序功能。

* math/big
数学/大数：使用任意大整数和有理数的多精度算术。


### container-list—ring—heap
实现用于操作集合的容器。

* list
列表：提供双向链表的操作。

下面是一个迭代list容器的例子：
```
for e := l.Front(); e != nil; e = e.Next() {
	// do something with e.Value
}
```

* ring
提供环形链表的操作函数。

### time—log

* time
时间：处理时间和日期的基本功能。

* log
日志：提供为正在运行的程序记录信息的功能。


### encoding/json—encoding/xml—text/template

* encoding/json
实现读取/解码以及在JSON forwmat中写入/编码数据的功能

* encoding / xml
简单的XML 1.0解析器; 有关json和xml的示例。

* text/template
文本/模板：制作数据驱动的模板，可以生成与数据混合的文本输出，如HTML

### net—net/http—html 

* net
处理网络数据的基本功能

* http
解析HTTP请求/回复的功能，提供了一个可扩展的HTTP服务器和一个基本的客户端。

* HTML
HTML5解析器。

### crypto—encoding—hash—…
包含多个加解密的函数包。

### runtime—reflect

* runtime
用于与Go运行时交互的操作，例如垃圾收集和goroutines。

* reflect
实现运行时自省，允许程序操作任意类型的变量。

* exp
试验包。后面的版本中，可能会被去掉。Go 1中不包含该包。


## regexp包

## 锁(Locking)和同步(sync)包

## 精确计算和大数包


## 自定义包和外部包的使用、安装、测试、安装

### 自定义包和可见性

### 在自定义包中使用godoc

### 使用go install安装自定义包


## 自定义包: map structure, go install 和 go test


