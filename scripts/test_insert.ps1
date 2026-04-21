$envPath = Join-Path $PSScriptRoot '..\\.env'
Get-Content $envPath | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]*)=(.*)$') {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim().Trim('"')
        Set-Item -Path "Env:$name" -Value $value
    }
}

$url = "$($env:SUPABASE_URL)/rest/v1/ai_tools"
$key = $env:SUPABASE_ANON_KEY
$headers = @{
    "apikey"        = $key
    "Authorization" = "Bearer $key"
    "Content-Type"  = "application/json"
}

$obj = [PSCustomObject]@{
    id            = "test_tool_unique"
    name          = "Test Tool Unique"
    category_id   = "chat"
    slug          = "test-tool-unique"
    description   = "A test description"
    icon_emoji    = "🔍"
    website_url   = "https://example.com"
    has_free_tier = $true
    is_featured   = $false
    click_count   = 0
}

$body = $obj | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
    Write-Host "SUCCESS: Response: $response"
}
catch {
    Write-Host "FAILED"
    Write-Host "Message: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $respBody = $reader.ReadToEnd()
        Write-Host "Body: $respBody"
    }
    else {
        Write-Host "No response body available."
    }
}
