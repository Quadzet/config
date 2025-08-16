# Dotfiles Setup Script for Windows 11
# Run this script as Administrator for best results

param(
    [string]$ConfigRepoPath = (Get-Location).Path,
    [switch]$Force
)

Write-Host "Setting up dotfiles from: $ConfigRepoPath" -ForegroundColor Green

# Function to create symbolic links safely
function New-SymLink {
    param(
        [string]$Target,
        [string]$Link,
        [string]$Description
    )
    
    if (Test-Path $Link) {
        if ($Force) {
            Write-Host "Removing existing $Description..." -ForegroundColor Yellow
            Remove-Item $Link -Force -Recurse
        } else {
            Write-Host "$Description already exists. Use -Force to overwrite." -ForegroundColor Yellow
            return
        }
    }
    
    # Ensure target directory exists
    $linkDir = Split-Path $Link -Parent
    if (-not (Test-Path $linkDir)) {
        New-Item -ItemType Directory -Path $linkDir -Force | Out-Null
    }
    
    try {
        New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force | Out-Null
        Write-Host "[SUCCESS] Created symbolic link for $Description" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to create symbolic link for $Description : $_" -ForegroundColor Red
    }
}

# Function to set environment variable
function Set-UserEnvVar {
    param(
        [string]$Name,
        [string]$Value,
        [string]$Description
    )
    
    try {
        [System.Environment]::SetEnvironmentVariable($Name, $Value, "User")
        Set-Item "env:$Name" $Value  # Set for current session too
        Write-Host "[SUCCESS] Set environment variable $Name for $Description" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to set environment variable $Name : $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Setting up Vim ===" -ForegroundColor Cyan

# Vim config (.vimrc)
$vimConfigSource = Join-Path $ConfigRepoPath "vim\.vimrc"
$vimConfigDest = "$env:USERPROFILE\.vimrc"

if (Test-Path $vimConfigSource) {
    New-SymLink -Target $vimConfigSource -Link $vimConfigDest -Description "Vim config (.vimrc)"
    
    # Set MYVIMRC environment variable for Vim as well
    Set-UserEnvVar -Name "MYVIMRC" -Value $vimConfigSource -Description "Vim config file"
} else {
    Write-Host "[ERROR] Vim config file not found at $vimConfigSource" -ForegroundColor Red
}

# Vim directory (for plugins, colors, etc.)
$vimDirSource = Join-Path $ConfigRepoPath "vim\.vim"
$vimDirDest = "$env:USERPROFILE\.vim"

if (Test-Path $vimDirSource) {
    New-SymLink -Target $vimDirSource -Link $vimDirDest -Description "Vim directory (.vim)"
} else {
    Write-Host "[INFO] Vim directory not found at $vimDirSource (optional)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Setting up Neovim ===" -ForegroundColor Cyan

# Neovim config
$nvimConfigSource = Join-Path $ConfigRepoPath "nvim"
$nvimConfigDest = "$env:LOCALAPPDATA\nvim"

if (Test-Path $nvimConfigSource) {
    New-SymLink -Target $nvimConfigSource -Link $nvimConfigDest -Description "Neovim config"
    
    # Set MYVIMRC environment variable
    $initFile = Join-Path $nvimConfigSource "init.vim"
    if (Test-Path $initFile) {
        Set-UserEnvVar -Name "MYVIMRC" -Value $initFile -Description "Neovim init file"
    } else {
        # Check for init.lua
        $initFile = Join-Path $nvimConfigSource "init.lua"
        if (Test-Path $initFile) {
            Set-UserEnvVar -Name "MYVIMRC" -Value $initFile -Description "Neovim init file"
        }
    }
} else {
    Write-Host "[ERROR] Neovim config folder not found at $nvimConfigSource" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Setting up Git ===" -ForegroundColor Cyan

# Git config
$gitConfigSource = Join-Path $ConfigRepoPath "git\.gitconfig"
$gitConfigDest = "$env:USERPROFILE\.gitconfig"

if (Test-Path $gitConfigSource) {
    New-SymLink -Target $gitConfigSource -Link $gitConfigDest -Description "Git config"
} else {
    Write-Host "[ERROR] Git config file not found at $gitConfigSource" -ForegroundColor Red
}

# Git global ignore
$gitIgnoreSource = Join-Path $ConfigRepoPath "git\.gitignore_global"
$gitIgnoreDest = "$env:USERPROFILE\.gitignore_global"

if (Test-Path $gitIgnoreSource) {
    New-SymLink -Target $gitIgnoreSource -Link $gitIgnoreDest -Description "Git global ignore"
    # Configure git to use the global gitignore
    git config --global core.excludesfile $gitIgnoreDest
    Write-Host "[SUCCESS] Configured git to use global gitignore" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Setting up Windows Terminal ===" -ForegroundColor Cyan

# Windows Terminal settings
$wtConfigSource = Join-Path $ConfigRepoPath "windows-terminal\settings.json"
$wtConfigDest = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (Test-Path $wtConfigSource) {
    New-SymLink -Target $wtConfigSource -Link $wtConfigDest -Description "Windows Terminal config"
} else {
    Write-Host "[ERROR] Windows Terminal config not found at $wtConfigSource" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Adding Config Repository to PATH ===" -ForegroundColor Cyan

# Add scripts directory to PATH if it exists
$scriptsDir = Join-Path $ConfigRepoPath "scripts"
if (Test-Path $scriptsDir) {
    $currentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$scriptsDir*") {
        $newPath = $currentPath + ";" + $scriptsDir
        [System.Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        $env:PATH += ";$scriptsDir"
        Write-Host "[SUCCESS] Added scripts directory to PATH" -ForegroundColor Green
    } else {
        Write-Host "[SUCCESS] Scripts directory already in PATH" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host "Please restart your terminal or run 'refreshenv' to reload environment variables." -ForegroundColor Yellow
Write-Host ""
Write-Host "To undo these changes, you can delete the symbolic links and reset environment variables manually." -ForegroundColor Gray

# Create an uninstall script
$uninstallContent = @"
# Uninstall script - removes symbolic links created by setup-configs.ps1

Write-Host "Removing dotfiles symbolic links..." -ForegroundColor Yellow

Remove-Item "$vimConfigDest" -Force -ErrorAction SilentlyContinue
Remove-Item "$vimDirDest" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "$nvimConfigDest" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "$gitConfigDest" -Force -ErrorAction SilentlyContinue  
Remove-Item "$gitIgnoreDest" -Force -ErrorAction SilentlyContinue
Remove-Item "$wtConfigDest" -Force -ErrorAction SilentlyContinue

[System.Environment]::SetEnvironmentVariable("MYVIMRC", `$null, "User")

Write-Host "Dotfiles uninstalled successfully!" -ForegroundColor Green
"@

$uninstallPath = Join-Path $ConfigRepoPath "uninstall-configs.ps1"
$uninstallContent | Out-File -FilePath $uninstallPath -Encoding UTF8
Write-Host "Created uninstall-configs.ps1 for easy removal." -ForegroundColor Cyan