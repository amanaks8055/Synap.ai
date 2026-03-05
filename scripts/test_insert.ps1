$url = "https://ssemwzmwhlcfmzmrweuw.supabase.co/rest/v1/ai_tools"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzZW13em13aGxjZm16bXJ3ZXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIxNzkxMTcsImV4cCI6MjA4Nzc1NTExN30.QF9G86V2HxzMrnN37ENQkrY7L_m7LBuxa56tC5MoywA"
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
