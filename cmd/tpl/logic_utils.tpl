package {{clearUnderline .Model}}

func modelToTypes(from *model.{{convertToCamelCase .Model}}) *types.{{convertToCamelCase .Model}} {
	tmp := &types.{{convertToCamelCase .Model}}{}
	_ = copier.Copy(tmp, from)
	tmp.CreatedAt = from.CreatedAt.UnixMilli()
    tmp.UpdatedAt = from.UpdatedAt.UnixMilli()
	// todo: custom trans
	return tmp
}
