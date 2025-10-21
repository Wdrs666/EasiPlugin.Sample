# Remove cilog files from git and disk
# Usage: Run in repository root in PowerShell

$cilog = Join-Path $PSScriptRoot '..\cilog'
$cilog = (Resolve-Path $cilog).ProviderPath
Write-Host "Removing files under $cilog"
if (Test-Path $cilog) {
    Get-ChildItem -Path $cilog -Recurse -Force | ForEach-Object {
        Write-Host "Removing file: $($_.FullName)"
        Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
    }
    # Remove directory if empty
    Get-ChildItem -Path $cilog -Recurse -Force | Measure-Object | ForEach-Object {
        if ($_.Count -eq 0) {
            Write-Host "Removing directory: $cilog"
            Remove-Item -Path $cilog -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
    # Stage removals for git
    Write-Host 'Staging git changes (removals)'
    git add -A
    Write-Host 'Please commit the changes: git commit -m "Remove cilog logs"'
} else {
    Write-Host 'cilog directory not found.'
}
