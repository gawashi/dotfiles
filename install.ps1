# 既存のプロファイルがあれば削除
if (Test-Path $PROFILE) {
    Remove-Item $PROFILE -Force
}

# プロファイルディレクトリが存在しない場合は作成
$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}

# シンボリックリンクを作成
$dotPROFILE = "$PSScriptRoot\Microsoft.PowerShell_profile.ps1"
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $dotPROFILE
Write-Host "Created symlink: $PROFILE -> $dotPROFILE"
