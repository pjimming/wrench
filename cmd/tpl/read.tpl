package {{clearUnderline .Model}}

import (
	"context"

	"github.com/pjimming/zustacm/core/internal/svc"
	"github.com/pjimming/zustacm/core/internal/types"
	"github.com/pjimming/zustacm/core/model"
	"github.com/pjimming/zustacm/core/utils/errorx"
	"github.com/pjimming/zustacm/core/utils/sqlbuilder"

	"github.com/zeromicro/go-zero/core/logx"
)


type Get{{convertToCamelCase .Model}}Logic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewGet{{convertToCamelCase .Model}}Logic(ctx context.Context, svcCtx *svc.ServiceContext) *Get{{convertToCamelCase .Model}}Logic {
	return &Get{{convertToCamelCase .Model}}Logic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *Get{{convertToCamelCase .Model}}Logic) Get{{convertToCamelCase .Model}}(req *types.Get{{convertToCamelCase .Model}}Req) (resp *types.Get{{convertToCamelCase .Model}}Resp, err error) {

	resp = &types.Get{{convertToCamelCase .Model}}Resp{
		Items: make([]*types.{{convertToCamelCase .Model}}, 0),
		Total: 0,
	}

	sb := sqlbuilder.NewSQLBuilder(l.ctx, l.svcCtx.DB.Model(&model.{{convertToCamelCase .Model}}{})).
		// todo: custom query
		OrderDesc("updated_at").
		ToSession()

	{{convertToLowerCamelCase .Model}}s, count, err := l.svcCtx.{{convertToCamelCase .Model}}.QueryPage(sb, req.Page, req.Size)
	if err != nil {
		err = errorx.ErrorDB(err)
		return nil, err
	}

	resp.Total = count

	for _, {{convertToLowerCamelCase .Model}} := range {{convertToLowerCamelCase .Model}}s {
		resp.Items = append(resp.Items, modelToTypes({{convertToLowerCamelCase .Model}}))
	}

	return
}
