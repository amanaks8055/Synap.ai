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

set "u=%SUPABASE_URL%/rest/v1/ai_tools"
set "k=%SUPABASE_ANON_KEY%"

echo Test Insert...
curl.exe -v -X POST "%u%" -H "apikey: %k%" -H "Authorization: Bearer %k%" -H "Content-Type: application/json" -H "Prefer: resolution=merge-duplicates" -d "[{\"id\":\"check_rls\",\"name\":\"Check RLS\",\"category_id\":\"chat\",\"slug\":\"check-rls\",\"description\":\"test\"}]"

pause
