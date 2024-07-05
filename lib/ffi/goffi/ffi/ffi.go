package ffi

/*
#include "stdint.h"
#include "include/dart_api_dl.c"

// Go does not allow calling C function pointers directly. So we are
// forced to provide a trampoline.
bool GoDart_PostCObject(Dart_Port_DL port, Dart_CObject* obj) {
  return Dart_PostCObject_DL(port, obj);
}
*/
import "C"

import "unsafe"

func SendToPort(port int64, msg int64) bool {
	var obj C.Dart_CObject
	obj._type = C.Dart_CObject_kInt64
	// cgo does not support unions so we are forced to do this
	*(*C.int64_t)(unsafe.Pointer(&obj.value[0])) = C.int64_t(msg)
	return bool(C.GoDart_PostCObject(C.int64_t(port), &obj))
}

func InitializeDartApi(api unsafe.Pointer) int {
	if C.Dart_InitializeApiDL(api) != 0 {
		return 1
	}
	return 0
}
