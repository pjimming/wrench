package config

import "github.com/zeromicro/go-zero/core/conf"

var GlobalConfig Config

func init() {
	conf.MustLoad("/Users/panjiangming/Project/zust-acm/gen/gen.yaml", &GlobalConfig)
}

type Config struct {
	Version  string
	Database struct {
		Dsn               string
		Db                string
		OutPath           string
		OutFile           string
		OnlyModel         bool
		WithUnitTest      bool
		ModelPkgName      string
		FieldNullable     bool
		FieldWithIndexTag bool
		FieldWithTypeTag  bool
	}
}
