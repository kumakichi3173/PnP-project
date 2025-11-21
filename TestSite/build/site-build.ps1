# =========================================== 
# site-build.ps1
# SharePoint Online ゼロからサイト構築用スクリプト（旧版 PnP 専用）
# ===========================================

# -----------------------------
# 1. 接続設定
# -----------------------------
Write-Host "=== Connect-PnPOnline で接続 ==="
# Connect-PnPOnline -Url "https://cgpinc.sharepoint.com/sites/CaitacApps-TheHubSiteProd" -UseWebLogin

# -----------------------------
# 2. サイト作成（旧版）
# ※旧版では Add-PnPSite は存在せず、CommunicationSite 作成機能は非対応
# -----------------------------
Write-Host "=== サイト作成（旧版はスキップ推奨） ==="
# 旧版は New-PnPSite コマンドが存在しません

# -----------------------------
# 3. リスト作成（旧版は New-PnPList）
# -----------------------------
Write-Host "=== リスト作成 ==="
$lists = @("Tasks", "Documents")
foreach ($list in $lists) {
    Write-Host "作成予定リスト: $list"
    New-PnPList -Title $list -Template GenericList
}

# -----------------------------
# 4. 列作成（旧版OK）
# -----------------------------
Write-Host "=== 列作成 ==="
$fields = @(
    @{ List="Tasks"; Name="DueDate"; Display="Due Date"; Type="DateTime" },
    @{ List="Tasks"; Name="AssignedTo"; Display="Assigned To"; Type="User" }
)
foreach ($f in $fields) {
    Write-Host "作成予定列: $($f.Display)"
    # Add-PnPField -List $f.List -DisplayName $f.Display -InternalName $f.Name -Type $f.Type
}

# -----------------------------
# 5. ページ作成（旧版）
# -----------------------------
Write-Host "=== ページ作成・Webパーツ配置 ==="
$pages = @("Home", "ProjectOverview")
foreach ($p in $pages) {
    Write-Host "作成予定ページ: $p"
    # Add-PnPClientSidePage -Name "$p.aspx" -LayoutType Home
    # Add-PnPClientSideWebPart -Page "$p.aspx" -DefaultWebPartType DocumentLibrary
}

# -----------------------------
# 6. 権限設定（旧版OK）
# -----------------------------
Write-Host "=== 権限設定 ==="
$groups = @(
    @{ Group = "Members"; Users = @("user1@caitacgarment.com") },
    @{ Group = "Visitors"; Users = @("user2@caitacgarment.com") }
)
foreach ($g in $groups) {
    Write-Host "グループ $($g.Group) に $($g.Users -join ', ') を追加予定"
    # foreach ($u in $g.Users) {
    #     Add-PnPGroupMember -Identity $g.Group -Users $u
    # }
}

Write-Host "=== 旧版PnP専用 site-build.ps1: 完成！ ==="
