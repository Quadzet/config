# Uninstall script - removes symbolic links created by setup-configs.ps1

Write-Host "Removing dotfiles symbolic links..." -ForegroundColor Yellow

Remove-Item "C:\Users\Joakim\.vimrc" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Users\Joakim\.vim" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "C:\Users\Joakim\AppData\Local\nvim" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "C:\Users\Joakim\.gitconfig" -Force -ErrorAction SilentlyContinue  
Remove-Item "C:\Users\Joakim\.gitignore_global" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Users\Joakim\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force -ErrorAction SilentlyContinue

[System.Environment]::SetEnvironmentVariable("MYVIMRC", $null, "User")

Write-Host "Dotfiles uninstalled successfully!" -ForegroundColor Green
