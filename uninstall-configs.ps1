# Uninstall script - removes symbolic links created by setup-configs.ps1

Write-Host "Removing dotfiles symbolic links..." -ForegroundColor Yellow

Remove-Item "C:\Users\S2304G\.vimrc" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Users\S2304G\.vim" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "C:\Users\S2304G\AppData\Local\nvim" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "C:\Users\S2304G\.gitconfig" -Force -ErrorAction SilentlyContinue  
Remove-Item "C:\Users\S2304G\.gitignore_global" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Users\S2304G\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force -ErrorAction SilentlyContinue

[System.Environment]::SetEnvironmentVariable("MYVIMRC", $null, "User")

Write-Host "Dotfiles uninstalled successfully!" -ForegroundColor Green
