echo Test: Crear TODO
curl -s -X POST https://1i8xbf0qhe.execute-api.us-east-1.amazonaws.com/Stage/todos -H "Content-Type: application/json" -d "{\"text\": \"Integration test from curl\"}" > create.json
type create.json

REM Obtener ID
for /f "tokens=2 delims=:,}" %%a in ('findstr /i "id" create.json') do set TODO_ID=%%~a
set TODO_ID=%TODO_ID:"=%

echo TODO_ID: %TODO_ID%

echo Test: Listar TODOs
curl -s -X GET https://1i8xbf0qhe.execute-api.us-east-1.amazonaws.com/Stage/todos > list.json
type list.json

echo Test: Obtener TODO por ID
curl -s -X GET https://1i8xbf0qhe.execute-api.us-east-1.amazonaws.com/Stage/todos/%TODO_ID% > get.json
type get.json

echo Test: Actualizar TODO por ID
curl -s -X PUT https://1i8xbf0qhe.execute-api.us-east-1.amazonaws.com/Stage/todos/%TODO_ID% -H "Content-Type: application/json" -d "{\"text\": \"Integration test modified\", \"checked\": true}" > update.json
type update.json

echo Test: Eliminar TODO por ID
curl -s -X DELETE https://1i8xbf0qhe.execute-api.us-east-1.amazonaws.com/Stage/todos/%TODO_ID% > delete.json
type delete.json

echo Validación completada
