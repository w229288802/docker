cd cframe
set GOOS=linux
go build -o ../opt/apiserver/ ./apiserver
go build -o ../opt/controller/ ./controller
go build -o ../opt/edge/ ./edge
rem
copy apiserver\config.toml ..\opt\apiserver\
copy controller\config.toml ..\opt\controller\
copy edge\config.toml ..\opt\edge\