@echo off
setlocal EnableExtensions

for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%~dp0..\.env") do (
	if not "%%A"=="" set "%%A=%%B"
)

if "%SUPABASE_URL%"=="" (
	echo SUPABASE_URL missing in .env
	exit /b 1
)
if "%SUPABASE_ANON_KEY%"=="" (
	echo SUPABASE_ANON_KEY missing in .env
	exit /b 1
)

curl.exe -X POST "%SUPABASE_URL%/rest/v1/ai_tools" -H "apikey: %SUPABASE_ANON_KEY%" -H "Authorization: Bearer %SUPABASE_ANON_KEY%" -H "Content-Type: application/json" -d @body.json
