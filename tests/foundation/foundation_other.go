//go:build !darwin || !cgo

package main

func foundationImportProbe() bool {
	return true
}
