# =========================================== 
# site-update.ps1
# SharePoint Online Dev → Prod 更新スクリプト
# ===========================================

param(
    [Parameter(Mandatory=$false)]
    [string]$DevUrl = "https://cgpinc.sharepoint.com/sites/CaitacApps-TheHubSiteDev",
    
    [Parameter(Mandatory=$false)]
    [string]$ProdUrl = "https://cgpinc.sharepoint.com/sites/CaitacApps-TheHubSiteProd",
    
    [Parameter(Mandatory=$false)]
    [string]$TemplatePath = "..\templates\DevTemplate.xml"
)

# -----------------------------
# Step 1: Dev環境からテンプレートを取得
# -----------------------------
Write-Host "=== Step 1: Dev環境に接続してテンプレート取得 ===" -ForegroundColor Cyan
try {
    Connect-PnPOnline -Url $DevUrl -UseWebLogin
    Write-Host "✓ Dev環境に接続成功" -ForegroundColor Green
    
    # テンプレート取得
    Get-PnPProvisioningTemplate -Out $TemplatePath -Force
    Write-Host "✓ テンプレート取得完了: $TemplatePath" -ForegroundColor Green
}
catch {
    Write-Host "✗ エラー: $_" -ForegroundColor Red
    exit 1
}

# -----------------------------
# Step 2: Prod環境にテンプレートを適用
# -----------------------------
Write-Host "`n=== Step 2: Prod環境に接続してテンプレート適用 ===" -ForegroundColor Cyan
try {
    Connect-PnPOnline -Url $ProdUrl -UseWebLogin
    Write-Host "✓ Prod環境に接続成功" -ForegroundColor Green
    
    # テンプレート適用
    Apply-PnPProvisioningTemplate -Path $TemplatePath
    Write-Host "✓ テンプレート適用完了" -ForegroundColor Green
}
catch {
    Write-Host "✗ エラー: $_" -ForegroundColor Red
    exit 1
}

# -----------------------------
# Step 3: 検証
# -----------------------------
Write-Host "`n=== Step 3: 更新の検証 ===" -ForegroundColor Cyan
try {
    $lists = Get-PnPList
    Write-Host "✓ Prod環境のリスト数: $($lists.Count)" -ForegroundColor Green
    
    foreach ($list in $lists | Where-Object { $_.Hidden -eq $false }) {
        Write-Host "  - $($list.Title)" -ForegroundColor Gray
    }
}
catch {
    Write-Host "✗ 検証エラー: $_" -ForegroundColor Red
}

Write-Host "`n=== 完了！ ===" -ForegroundColor Green
