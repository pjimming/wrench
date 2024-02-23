FindOne(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) (*{{.upperStartCamelObject}}, error)
QueryPage(tx *gorm.DB, page, size int) ([]*{{.upperStartCamelObject}}, int64, error)