# =========================================== 
# watch-and-deploy.ps1
# ファイル監視＆自動デプロイスクリプト
# ===========================================

param(
    [Parameter(Mandatory=$false)]
    [string]$WatchPath = "..\templates",
    
    [Parameter(Mandatory=$false)]
    [string]$DevUrl = "https://cgpinc.sharepoint.com/sites/CaitacApps-TheHubSiteDev",
    
    [Parameter(Mandatory=$false)]
    [string]$ProdUrl = "https://cgpinc.sharepoint.com/sites/CaitacApps-TheHubSiteProd"
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  ファイル監視＆自動デプロイ開始" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "監視フォルダ: $WatchPath" -ForegroundColor Yellow
Write-Host "Dev環境: $DevUrl" -ForegroundColor Yellow
Write-Host "Prod環境: $ProdUrl" -ForegroundColor Yellow
Write-Host "`nCtrl+C で終了`n" -ForegroundColor Gray

# Dev環境に事前接続
Write-Host "Dev環境に接続中..." -ForegroundColor Cyan
try {
    Connect-PnPOnline -Url $DevUrl -UseWebLogin
    Write-Host "✓ Dev環境に接続成功`n" -ForegroundColor Green
}
catch {
    Write-Host "✗ 接続エラー: $_" -ForegroundColor Red
    exit 1
}

# ファイル監視の設定
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = Resolve-Path $WatchPath
$watcher.Filter = "*.xml"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# 変更イベントの処理
$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Write-Host "`n[$timestamp] 変更検出: $changeType - $path" -ForegroundColor Yellow
    
    # 少し待機（ファイルが完全に保存されるまで）
    Start-Sleep -Seconds 2
    
    try {
        Write-Host "  → Dev環境からテンプレート取得中..." -ForegroundColor Cyan
        Get-PnPProvisioningTemplate -Out $path -Force
        Write-Host "  ✓ テンプレート更新完了" -ForegroundColor Green
        
        # オプション: Prod環境にも自動適用する場合（コメントを外す）
        # Write-Host "  → Prod環境に適用中..." -ForegroundColor Cyan
        # Connect-PnPOnline -Url $ProdUrl -UseWebLogin
        # Apply-PnPProvisioningTemplate -Path $path
        # Write-Host "  ✓ Prod環境に適用完了" -ForegroundColor Green
        
        Write-Host "  ✓ 処理完了！`n" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ エラー: $_`n" -ForegroundColor Red
    }
}

# イベント登録
$handlers = @(
    (Register-ObjectEvent $watcher "Changed" -Action $action),
    (Register-ObjectEvent $watcher "Created" -Action $action)
)

Write-Host "監視を開始しました。テンプレートファイルを編集すると自動的に更新されます。" -ForegroundColor Green

# 監視を継続（Ctrl+Cで終了）
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    # クリーンアップ
    $handlers | ForEach-Object { Unregister-Event -SourceIdentifier $_.Name }
    $watcher.Dispose()
    Write-Host "`n監視を終了しました。" -ForegroundColor Yellow
}
