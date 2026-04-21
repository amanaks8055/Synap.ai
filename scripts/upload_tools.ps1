$envPath = Join-Path $PSScriptRoot '..\\.env'
Get-Content $envPath | ForEach-Object {
    if ($_ -match '^\s*([^#][^=]*)=(.*)$') {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim().Trim('"')
        Set-Item -Path "Env:$name" -Value $value
    }
}

$supabaseUrl = $env:SUPABASE_URL
$anonKey = $env:SUPABASE_ANON_KEY
$headers = @{
    "apikey"        = $anonKey
    "Authorization" = "Bearer $anonKey"
    "Content-Type"  = "application/json"
    "Prefer"        = "resolution=merge-duplicates"
}

$allTools = @()

# Process each batch file in migrations folder
$migrationsPath = "C:\Users\Aman sharma\Desktop\Synap\supabase\migrations"
$files = Get-ChildItem -Path $migrationsPath -Filter "*_tools_batch*.sql" | Sort-Object Name

foreach ($file in $files) {
    $filePath = $file.FullName
    if (Test-Path $filePath) {
        Write-Host "--- Reading $filePath ---" -ForegroundColor Cyan
        $content = Get-Content $filePath -Raw
        
        # Super robust regex for the SQL VALUES format
        # Matches ('id', 'name', 'slug', 'category', 'description', 'icon', 'url', true/false, true/false, click_count)
        # Handles escaped quotes '' in any field, and empty fields
        $regex = "\('((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^'])+)','((?:''|[^']*)*)','((?:''|[^']*)*)',(true|false),(true|false),(\d+)\)"
        
        $toolMatches = [regex]::Matches($content, $regex)
        Write-Host "Found $($toolMatches.Count) items in $filePath" -ForegroundColor Gray
        
        foreach ($m in $toolMatches) {
            $tool = @{
                "id"            = $m.Groups[1].Value.Replace("''", "'")
                "name"          = $m.Groups[2].Value.Replace("''", "'")
                "slug"          = $m.Groups[3].Value.Replace("''", "'")
                "category_id"   = $m.Groups[4].Value.Replace("''", "'")
                "description"   = $m.Groups[5].Value.Replace("''", "'")
                "icon_emoji"    = $m.Groups[6].Value.Replace("''", "'")
                "website_url"   = $m.Groups[7].Value.Replace("''", "'")
                "has_free_tier" = $m.Groups[8].Value -eq "true"
                "is_featured"   = $m.Groups[9].Value -eq "true"
                "click_count"   = [int]$m.Groups[10].Value
            }
            $allTools += $tool
        }
    }
}

Write-Host "==============================="
Write-Host "Total tools parsed: $($allTools.Count)" -ForegroundColor Green
Write-Host "==============================="

if ($allTools.Count -eq 0) {
    Write-Host "No tools found to upload!" -ForegroundColor Red
    return
}

# Upload in batches of 50
$batchSize = 50
for ($i = 0; $i -lt $allTools.Count; $i += $batchSize) {
    $endIdx = $i + $batchSize - 1
    if ($endIdx -ge $allTools.Count) { $endIdx = $allTools.Count - 1 }
    
    $batch = $allTools[$i..$endIdx]
    $json = $batch | ConvertTo-Json -Depth 5 -Compress
    
    try {
        # Using Invoke-RestMethod for cleaner handling
        $response = Invoke-RestMethod -Uri "$supabaseUrl/rest/v1/ai_tools" -Method Post -Headers $headers -Body $json
        Write-Host "UPLOADED: Index $i to $endIdx ($($batch.Count) tools)" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED: Index $i to $endIdx" -ForegroundColor Red
        Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Yellow
        if ($_.Exception.Response) {
            $stream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $body = $reader.ReadToEnd()
            Write-Host "Response Body: $body" -ForegroundColor White
        }
    }
}

Write-Host "DONE! All tools processed." -ForegroundColor Green
