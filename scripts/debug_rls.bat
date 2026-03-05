@echo off
set "u=https://ssemwzmwhlcfmzmrweuw.supabase.co/rest/v1/ai_tools"
set "k=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA"

echo Test Insert...
curl.exe -v -X POST "%u%" -H "apikey: %k%" -H "Authorization: Bearer %k%" -H "Content-Type: application/json" -H "Prefer: resolution=merge-duplicates" -d "[{\"id\":\"check_rls\",\"name\":\"Check RLS\",\"category_id\":\"chat\",\"slug\":\"check-rls\",\"description\":\"test\"}]"

pause
