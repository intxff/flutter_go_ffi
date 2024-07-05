package main

/*
#include <stdlib.h>
#include "stdint.h"

typedef struct {
  char * tag;
  int64_t value;
} Latency;
*/
import "C"

import (
	"goffi/ffi"
	"time"
	"unsafe"
)

func main() {}

//export InitializeDartApi
func InitializeDartApi(api unsafe.Pointer) C.int64_t {
	return C.int64_t(ffi.InitializeDartApi(api))
}

//export SendTenNums
func SendTenNums(port C.int64_t) {
	for i := 0; i < 10; i++ {
		ffi.SendToPort(int64(port), int64(i))
		time.Sleep(time.Duration(time.Second))
	}
}
