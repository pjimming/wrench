import (
	"context"
	"fmt"
	{{if .time}}"time"{{end}}
	{{if .containsDbSql}}"database/sql"{{end}}

	"github.com/zeromicro/go-zero/core/stores/cache"
	"gorm.io/gorm"
)
