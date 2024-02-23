package main

import (
	"github.com/stretchr/testify/assert"
	"io"
	"os"
	"testing"
)

func TestReadTpl(t *testing.T) {
	f, err := os.Open("../dao.tpl")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	fd, err := io.ReadAll(f)
	if err != nil {
		panic(err)
	}

	t.Log(string(fd))
}

func TestGetTableFields(t *testing.T) {

	fields := getTableFields("resource")

	assert.NotNil(t, fields)
}

func TestConvertToCamelCase(t *testing.T) {
	assert.Equal(t, "AbcDefGhi", convertToCamelCase("abc_def_ghi"))
}

func TestConvertToUpperCamelCase(t *testing.T) {
	assert.Equal(t, "vultureDiskInfo", convertToLowerCamelCase("vulture_disk_info"))
}
