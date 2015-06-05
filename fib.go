package main

import "fmt"
import "time"

func fib(n int) int {
    if n < 2 {
        return 1
    }

    return fib(n-2) + fib(n-1)
}

func main() {
  start := time.Now()

    for i := 0; i < 40; i++ {
   fmt.Println(fib(i))

    }
  elapsed := time.Since(start)
  fmt.Printf("Fibonacci took %s", elapsed)
}
