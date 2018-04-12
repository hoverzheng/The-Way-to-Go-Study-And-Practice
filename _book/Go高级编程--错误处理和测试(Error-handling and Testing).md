# 错误处理和测试(Error-handling and Testing)

Go中没有java和.net中的try/catch机制，go认为这套机制消耗的资源太大了。而是使用了defer-panic-and-recover这样的机制。

那么，默认情况下go是如何处理错误的呢？go处理错误的方式是，让函数返回一个错误对象，在函数运行结束时判断该错误对象是否为nil，若为nil则没有错误发生，若不为nil在有错误发生。

注意：不要忽略错误，因为错误可能使得程序崩溃。


## 错误处理err := errors.New(“math - square root of negative number”)
Go中定义了一个错误处理的接口：
```

type error interface {
    Error() string
}
```

包错误有一个errorString实现了error接口，为了停止执行一个发生错误的程序，我们可以使用os.Exit(1)。


### 定义新的错误
任何时候你想定义一个新的错误类型，只需要使用errors包的errors.New函数，并为该函数设置一个说明错误的字符串。如下面的形式：
```
err := errors.New("math - square root of negative number")
```

下面是一个简单的定义并使用新的错误类型的例子：
```
package main
import (
    "errors"
    "fmt"
)

var errNotFound error = errors.New("Not found error")
func main() {
    fmt.Printf("error: %v", errNotFound)
}
// error: Not found error
```

在定义函数时，可以使用error变量：
```
func Sqrt(f float64) (float64, error) {
    if f < 0 {
        return 0, errors.New ("math - square root of negative number")
    }
    // implementation of Sqrt
}

使用的时候，就可以按下面的方式：

if f, err := Sqrt(-1); err != nil {
    fmt.Printf(“Error: %s\n”, err)
}

```







