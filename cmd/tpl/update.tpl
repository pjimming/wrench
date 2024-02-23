package {{clearUnderline .Model}}

import (
	"context"

	"github.com/pjimming/zustacm/core/internal/svc"
	"github.com/pjimming/zustacm/core/internal/types"
	"github.com/pjimming/zustacm/core/utils/errorx"

	"github.com/jinzhu/copier"
	"github.com/zeromicro/go-zero/core/logx"
)

type Update{{convertToCamelCase .Model}}Logic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewUpdate{{convertToCamelCase .Model}}Logic(ctx context.Context, svcCtx *svc.ServiceContext) *Update{{convertToCamelCase .Model}}Logic {
	return &Update{{convertToCamelCase .Model}}Logic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *Update{{convertToCamelCase .Model}}Logic) Update{{convertToCamelCase .Model}}(req *types.Update{{convertToCamelCase .Model}}Req) error {

	{{convertToLowerCamelCase .Model}}, err := l.svcCtx.{{convertToCamelCase .Model}}.FindOne(l.ctx, req.ID)
	if err != nil {
		err = errorx.ErrorDB(err)
		return err
	}

	_ = copier.Copy({{convertToLowerCamelCase .Model}}, req)
	// todo: custom trans

	if err = l.svcCtx.{{convertToCamelCase .Model}}.Update(l.ctx, l.svcCtx.DB, {{convertToLowerCamelCase .Model}}); err != nil {
		err = errorx.ErrorDB(err)
		return err
	}

	return nil
}
