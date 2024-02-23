syntax = "v1"

info(
	title: "{{.Model}}"
	desc: "{{.Model}} apis"
	author: "panjiangming"
	email: "panjm2001@126.com"
	version: "v1"
)

type (
	{{convertToCamelCase .Model}} {
		ID        int64  `json:"id"`         // 序号
		CreatedAt int64  `json:"created_at"` // 创建时间
		UpdatedAt int64  `json:"updated_at"` // 更新时间
		{{range .Fields -}}
            {{if and (ne .Name "id") (ne .Name "created_at") (ne .Name "updated_at") (ne .Name "deleted_at")  (ne .Name "deleted")  (ne .Name "created")  (ne .Name "updated") -}}
                {{convertToCamelCase .Name}}	{{.Type}} {{.Tag}}
            {{else -}}
            {{end}}
        {{- end}}
	}

	Add{{convertToCamelCase .Model}}Req {
		{{range .Fields -}}
            {{if and (ne .Name "id") (ne .Name "created_at") (ne .Name "updated_at") (ne .Name "deleted_at")  (ne .Name "deleted")  (ne .Name "created")  (ne .Name "Updated") -}}
                {{convertToCamelCase .Name}}	{{.Type}} {{.Tag}}
            {{else -}}
            {{end}}
        {{- end}}
	}

	Get{{convertToCamelCase .Model}}Req {
		Page  int    `form:"page,default=1"`
		Size  int    `form:"size,default=10"`
		// todo: complete
	}

	Get{{convertToCamelCase .Model}}Resp {
		Items []*{{convertToCamelCase .Model}} `json:"items"`
		Total int64      `json:"total"`
	}

	Update{{convertToCamelCase .Model}}Req {
		ID     int64  `path:"id"`              // 序号
		{{range .Fields -}}
            {{if and (ne .Name "id") (ne .Name "created_at") (ne .Name "updated_at") (ne .Name "deleted_at")  (ne .Name "deleted")  (ne .Name "created")  (ne .Name "Updated") -}}
                {{convertToCamelCase .Name}}	{{.Type}} {{.Tag}}
            {{else -}}
            {{end}}
        {{- end}}
	}

	Delete{{convertToCamelCase .Model}}Req {
		ID int64 `path:"id"`
	}
)

@server(
	group: {{toLower .Model}}
	middleware: JwtAuth
)
service core-api {
	@doc "新增"
	@handler Add{{convertToCamelCase .Model}}
	post /api/v1/{{toLower .Model}} (Add{{convertToCamelCase .Model}}Req)

	@doc "分页查询"
	@handler Get{{convertToCamelCase .Model}}
	get /api/v1/{{toLower .Model}} (Get{{convertToCamelCase .Model}}Req) returns (Get{{convertToCamelCase .Model}}Resp)

	@doc "更新信息"
	@handler Update{{convertToCamelCase .Model}}
	put /api/v1/{{toLower .Model}}/:id (Update{{convertToCamelCase .Model}}Req)

	@doc "删除"
	@handler Delete{{convertToCamelCase .Model}}
	delete /api/v1/{{toLower .Model}}/:id (Delete{{convertToCamelCase .Model}}Req)
}