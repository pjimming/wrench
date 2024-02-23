package {{clearUnderline .Model}}

import (
	"context"

	"github.com/pjimming/zustacm/core/internal/svc"
	"github.com/pjimming/zustacm/core/internal/types"
	"github.com/pjimming/zustacm/core/utils/errorx"

	"github.com/zeromicro/go-zero/core/logx"
)
type Delete{{convertToCamelCase .Model}}Logic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewDelete{{convertToCamelCase .Model}}Logic(ctx context.Context, svcCtx *svc.ServiceContext) *Delete{{convertToCamelCase .Model}}Logic {
	return &Delete{{convertToCamelCase .Model}}Logic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *Delete{{convertToCamelCase .Model}}Logic) Delete{{convertToCamelCase .Model}}(req *types.Delete{{convertToCamelCase .Model}}Req) error {

	if err := l.svcCtx.{{convertToCamelCase .Model}}.Delete(l.ctx, l.svcCtx.DB, req.ID); err != nil {
		err = errorx.ErrorDB(err)
		return err
	}

	return nil
}
