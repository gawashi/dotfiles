# Setup PowerShell profile symlink
if (Test-Path $PROFILE) {
    Remove-Item $PROFILE -Force
}

$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}

$dotPROFILE = "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $dotPROFILE
Write-Host "Created symlink: $PROFILE -> $dotPROFILE"

# Setup Claude Code symlinks
$dotClaudeDir = "$PSScriptRoot\.claude"
$homeClaudeDir = "${HOME}\.claude"
if (Test-Path $dotClaudeDir) {
    if (-not (Test-Path $homeClaudeDir)) {
        New-Item -ItemType Directory -Path $homeClaudeDir -Force | Out-Null
    }

    @("agents", "commands") | ForEach-Object {
        $target = "$dotClaudeDir\$_"
        $link = "$homeClaudeDir\$_"

        if ((Test-Path $target) -and -not (Test-Path $link)) {
            New-Item -ItemType SymbolicLink -Path $link -Target $target -Force | Out-Null
            Write-Host "Created symlink: $link -> $target"
        }
    }
}
