package {{clearUnderline .Model}}

import (
	"context"

	"github.com/pjimming/zustacm/core/internal/svc"
	"github.com/pjimming/zustacm/core/internal/types"
	"github.com/pjimming/zustacm/core/model"
	"github.com/pjimming/zustacm/core/utils/errorx"

	"github.com/jinzhu/copier"
	"github.com/zeromicro/go-zero/core/logx"
)

type Add{{convertToCamelCase .Model}}Logic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewAdd{{convertToCamelCase .Model}}Logic(ctx context.Context, svcCtx *svc.ServiceContext) *Add{{convertToCamelCase .Model}}Logic {
	return &Add{{convertToCamelCase .Model}}Logic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *Add{{convertToCamelCase .Model}}Logic) Add{{convertToCamelCase .Model}}(req *types.Add{{convertToCamelCase .Model}}Req) error {

	{{convertToLowerCamelCase .Model}} := &model.{{convertToCamelCase .Model}}{}
	_ = copier.Copy({{convertToLowerCamelCase .Model}}, req)
	// todo: custom trans

	if err := l.svcCtx.{{convertToCamelCase .Model}}.Insert(l.ctx, l.svcCtx.DB, {{convertToLowerCamelCase .Model}}); err != nil {
		err = errorx.ErrorDB(err)
		return err
	}

	return nil
}
