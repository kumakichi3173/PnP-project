# ===========================================
# site-build.ps1
# SharePoint Online ゼロからサイト構築用スクリプト（VS Code用）
# 実行は権限を持つユーザーが行う前提
# ===========================================

# -----------------------------
# 1. 接続設定
# -----------------------------
Write-Host "=== Connect-PnPOnline で接続する予定 ==="
# Connect-PnPOnline -Url "https://caitacgarment.sharepoint.com/sites/ProdSite" -UseWebLogin

# -----------------------------
# 2. サイト作成
# -----------------------------
Write-Host "=== サイト作成 ==="
# New-PnPSite -Type CommunicationSite -Title "ProdSite" -Url "https://caitacgarment.sharepoint.com/sites/ProdSite" -Owner "you@caitacgarment.com"

# -----------------------------
# 3. リスト作成
# -----------------------------
Write-Host "=== リスト作成 ==="
$lists = @("Tasks", "Documents")
foreach ($list in $lists) {
    Write-Host "作成予定リスト: $list"
    # Add-PnPList -Title $list -Template GenericList
}

# -----------------------------
# 4. 列作成
# -----------------------------
Write-Host "=== 列作成 ==="
$fields = @(
    @{ List="Tasks"; Name="Due Date"; Type="DateTime" },
    @{ List="Tasks"; Name="Assigned To"; Type="User" }
)
foreach ($field in $fields) {
    Write-Host "作成予定: $($field.List) の列 $($field.Name)"
    # Add-PnPField -List $field.List -DisplayName $field.Name -Type $field.Type
}

# -----------------------------
# 5. ページ作成・Webパーツ配置
# -----------------------------
Write-Host "=== ページ作成・Webパーツ配置 ==="
$pages = @("Home", "ProjectOverview")
foreach ($page in $pages) {
    Write-Host "作成予定ページ: $page"
    # Add-PnPPage -Name $page -Layout Home
    # Add-PnPClientSideWebPart -Page $page -DefaultWebPartType "DocumentLibrary" -WebPartProperties @{ "Title"="Documents" }
}

# -----------------------------
# 6. 権限設定
# -----------------------------
Write-Host "=== 権限設定 ==="
$groups = @(
    @{ Group = "Members"; Users = @("user1@caitacgarment.com", "user2@caitacgarment.com") },
    @{ Group = "Visitors"; Users = @("user3@caitacgarment.com") }
)
foreach ($g in $groups) {
    Write-Host "グループ $($g.Group) にユーザー追加予定: $($g.Users -join ', ')"
    # foreach ($u in $g.Users) {
    #     Add-PnPGroupMember -Identity $g.Group -Users $u
    # }
}

Write-Host "=== スクリプト構造完成。編集・レビュー可能 ==="