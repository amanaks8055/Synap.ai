$envPath = Join-Path $PSScriptRoot '..\.env'
Get-Content $envPath | ForEach-Object {
	if ($_ -match '^\s*([^#][^=]*)=(.*)$') {
		$name = $matches[1].Trim()
		$value = $matches[2].Trim().Trim('"')
		Set-Item -Path "Env:$name" -Value $value
	}
}

$Headers = @{ 'apikey' = $env:SUPABASE_SERVICE_ROLE_KEY }
$Definition = (Invoke-RestMethod -Uri "$($env:SUPABASE_URL)/rest/v1/" -Headers $Headers).definitions.ai_tools
$Definition | ConvertTo-Json -Depth 5
