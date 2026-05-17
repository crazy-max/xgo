//go:build darwin && cgo

package main

/*
#cgo CFLAGS: -x objective-c
#cgo LDFLAGS: -framework Foundation -framework LocalAuthentication
#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

static int xgoFoundationImportProbe(void) {
	return sizeof(NSString *) + sizeof(LAContext *);
}
*/
import "C"

func foundationImportProbe() bool {
	return C.xgoFoundationImportProbe() > 0
}
