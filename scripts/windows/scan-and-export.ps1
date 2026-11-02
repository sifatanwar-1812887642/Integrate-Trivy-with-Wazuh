# Reference workflow: scan the application and export one selected finding as JSONL.
# Run in an elevated PowerShell session on the authorized Windows lab endpoint.

$Report = "C:\trivy-report.json"
$Target = "C:\ClickFixAgent"
$OutputDir = "C:\ProgramData\Trivy"
$OutputFile = Join-Path $OutputDir "vulnerabilities.jsonl"
$Cve = "CVE-2026-58280"

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

trivy fs --scanners vuln --format json --output $Report $Target
if ($LASTEXITCODE -ne 0) {
    throw "Trivy scan failed with exit code $LASTEXITCODE"
}
if (-not (Test-Path $Report)) {
    throw "Trivy report was not created: $Report"
}

$r = Get-Content $Report -Raw | ConvertFrom-Json
$events = foreach ($res in $r.Results) {
    foreach ($v in $res.Vulnerabilities) {
        if ($v.VulnerabilityID -eq $Cve -and $res.Target -like "*bin/Release/*") {
            [pscustomobject]@{
                source            = "trivy"
                target            = $res.Target
                vulnerability_id  = $v.VulnerabilityID
                pkg_name           = $v.PkgName
                installed_version  = $v.InstalledVersion
                fixed_version      = $v.FixedVersion
                severity           = $v.Severity
                title              = $v.Title
            }
        }
    }
}

if (-not $events) {
    throw "Selected CVE $Cve was not found in the report. Review the report before forwarding."
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
foreach ($event in $events) {
    $line = $event | ConvertTo-Json -Compress
    [System.IO.File]::AppendAllText($OutputFile, $line + [Environment]::NewLine, $utf8NoBom)
}

Write-Host "Appended $($events.Count) selected event(s) to $OutputFile"
Write-Host "This script is a reference export workflow; configure and validate agent collection separately."
