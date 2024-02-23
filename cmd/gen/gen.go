package main

import (
	"encoding/json"
	"flag"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"github.com/pjimming/zustacm/gen/config"
	"io"
	"os"
	"path/filepath"
	"strings"
	"text/template"
	"xorm.io/core"
	"xorm.io/xorm"
)

const (
	ExtGolang = "go"
	ExtApi    = "api"
)

func main() {
	var model, api, logic, home string
	flag.StringVar(&model, "model", "", "生成数据表方法名")
	flag.StringVar(&api, "api", "../../core/apis", "生成api文件目标文件夹")
	flag.StringVar(&logic, "logic", "../../core/internal/logic", "生成logic文件目标文件夹")
	flag.StringVar(&home, "home", "../tpl", "生成文件模版")
	flag.Parse()

	if model == "" {
		panic("model is null")
	}

	home = strings.TrimSuffix(home, "/")

	// render api
	render(api, ExtApi, home+"/api.tpl",
		model,
		map[string]interface{}{
			"Model":  model,
			"Fields": getTableFields(model),
		})
	// render logic crud
	logic = strings.TrimSuffix(logic, "/")
	// - create
	render(
		fmt.Sprintf("%s/%s", logic, strings.ReplaceAll(model, "_", "")),
		ExtGolang,
		home+"/create.tpl",
		fmt.Sprintf("add_%s_logic", model),
		map[string]interface{}{"Model": model},
	)
	// - read
	render(
		fmt.Sprintf("%s/%s", logic, strings.ReplaceAll(model, "_", "")),
		ExtGolang,
		home+"/read.tpl",
		fmt.Sprintf("get_%s_logic", model),
		map[string]interface{}{"Model": model},
	)
	// - update
	render(
		fmt.Sprintf("%s/%s", logic, strings.ReplaceAll(model, "_", "")),
		ExtGolang,
		home+"/update.tpl",
		fmt.Sprintf("update_%s_logic", model),
		map[string]interface{}{"Model": model},
	)
	// -delete
	render(
		fmt.Sprintf("%s/%s", logic, strings.ReplaceAll(model, "_", "")),
		ExtGolang,
		home+"/delete.tpl",
		fmt.Sprintf("delete_%s_logic", model),
		map[string]interface{}{"Model": model},
	)
	// -utils
	render(
		fmt.Sprintf("%s/%s", logic, strings.ReplaceAll(model, "_", "")),
		ExtGolang,
		home+"/logic_utils.tpl",
		"utils",
		map[string]interface{}{"Model": model},
	)
}

func render(target, ext, tpl, filename string, data map[string]interface{}) {
	target = strings.TrimSuffix(target, "/")
	filePath := fmt.Sprintf("%s/%s.%s", target, filename, ext)
	filePath, _ = filepath.Abs(filePath)
	if isExist, _ := pathExists(filePath); isExist {
		fmt.Printf("%s exists, ignored generation\n", filePath)
		return
	}

	tplText, err := readTpl(tpl)
	if err != nil {
		panic(err)
	}

	tmpl, err := template.New("template").
		Funcs(template.FuncMap{
			"firstUpper":              firstUpper,
			"convertToLowerCamelCase": convertToLowerCamelCase,
			"toLower":                 strings.ToLower,
			"convertToCamelCase":      convertToCamelCase,
			"clearUnderline":          clearUnderline,
		}).
		Parse(tplText)
	if err != nil {
		panic(err)
	}

	if err = os.MkdirAll(filepath.Dir(filePath), 0755); err != nil {
		panic(err)
	}

	f, err := os.Create(filePath)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	if err = tmpl.Execute(f, data); err != nil {
		panic(err)
	}
	fmt.Printf("generate file: %s\n", filePath)
}

func firstUpper(s string) string {
	return strings.ToUpper(s[:1]) + s[1:]
}

func readTpl(tplPath string) (string, error) {
	f, err := os.Open(tplPath)
	if err != nil {
		return "", err
	}
	defer f.Close()

	fd, err := io.ReadAll(f)
	if err != nil {
		return "", err
	}

	return string(fd), nil
}

// pathExists 判断所给路径文件/文件夹是否存在
func pathExists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}

func convertToLowerCamelCase(input string) string {
	words := strings.Split(input, "_")
	for i := 1; i < len(words); i++ {
		words[i] = strings.Title(words[i])
	}
	return strings.Join(words, "")
}

func convertToCamelCase(s string) string {
	words := strings.Split(s, "_")
	for i := 0; i < len(words); i++ {
		words[i] = strings.Title(words[i])
	}
	return strings.Join(words, "")
}

func clearUnderline(s string) string {
	return strings.ReplaceAll(s, "_", "")
}

type TableField struct {
	Name string
	Type string
	Tag  string
}

func getTableFields(table string) []map[string]interface{} {
	dbEngine, err := xorm.NewEngine("mysql", config.GlobalConfig.Database.Dsn)
	if err != nil {
		panic(err)
	}

	tables, err := dbEngine.DBMetas()
	if err != nil {
		panic(err)
	}

	var ret []*TableField

	for _, item := range tables {
		if item.Name != table {
			continue
		}

		for _, column := range item.Columns() {
			field := &TableField{}
			// get type
			s := core.SQLType2Type(core.SQLType{
				Name:           column.SQLType.Name,
				DefaultLength:  int(column.SQLType.DefaultLength),
				DefaultLength2: int(column.SQLType.DefaultLength2),
			}).String()
			if s == "[]uint8" {
				s = "[]byte"
			}
			if s == "int" {
				s = "int64"
			}
			if s == "time.Time" {
				s = "string"
			}
			field.Type = s
			// get name
			field.Name = column.Name
			// get tag
			field.Tag = fmt.Sprintf("`json:\"%s\"`", field.Name)
			ret = append(ret, field)
		}
	}

	fields := make([]map[string]interface{}, 0)
	retBytes, _ := json.Marshal(ret)
	_ = json.Unmarshal(retBytes, &fields)

	return fields
}
