package main

// #include <stdio.h>
//
// void sayHi() {
//   printf("Hello, embedded C!\n");
// }
import "C"

func main() {
	C.sayHi()
}
