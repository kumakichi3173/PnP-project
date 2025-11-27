# SharePoint サイト構造のコピー - PnP PowerShell ガイド

## 📋 概要

このガイドでは、SharePointサイトの構造をDev環境からProd環境にコピーする方法を説明します。PnP PowerShellのプロビジョニングテンプレート機能を使用します。

## ✅ コピーできる要素

| 要素 | 説明 | 状態 |
|------|------|------|
| **Lists** | リスト構造（Tasks, Documents等） | ✅ コピー可能 |
| **Navigation** | QuickLaunch（左サイドバー）メニュー | ✅ コピー可能 |
| **Content Types** | カスタムコンテンツタイプ | ✅ コピー可能 |
| **Fields** | カスタム列定義 | ✅ コピー可能 |
| **Site Settings** | サイト設定 | ✅ コピー可能 |
| **Theme/Look** | テーマ・外観設定 | ✅ コピー可能 |
| **Features** | 有効化されている機能 | ✅ コピー可能 |
| **Regional Settings** | 地域・言語設定 | ✅ コピー可能 |

## ❌ コピーできない要素

| 要素 | 説明 | 理由 |
|------|------|------|
| **Pages** | サイトページ（ニュースページ等） | ⚠️ 旧版PnPとの互換性問題 |
| **List Data** | リスト内のアイテム | デフォルトでは含まれない |
| **Documents** | ドキュメントライブラリのファイル | デフォルトでは含まれない |
| **Hub Navigation** | ハブサイトレベルのナビゲーション | 手動設定が必要 |
| **Permissions** | 詳細な権限設定 | 一部のみコピー可能 |

### ⚠️ ページがコピーできない理由

**技術的な制約:**
- SharePointPnPPowerShellOnline（旧版）には、最新のSharePointページレイアウトとの互換性問題があります
- エラー: `Input string '1.0' is not a valid integer. Path 'position.sectionIndex'`
- これは、ページのセクションレイアウト情報が正しく解析できないために発生します

**回避策:**
1. ページ以外の構造をテンプレート化
2. ページは手動でコピー、または別途エクスポート/インポート
3. 新しい PnP.PowerShell モジュール（クロスプラットフォーム版）へのアップグレードを検討

## 🚀 実行手順

### Step 1: Dev環境に接続

```powershell
# Dev環境に接続
Connect-PnPOnline -Url "https://cgpinc.sharepoint.com/sites/Test-HubSiteDev" -UseWebLogin
```

### Step 2: テンプレートを抽出

```powershell
# ページ以外の全構造をテンプレート化
Get-PnPProvisioningTemplate -Out "DevTemplate-Complete.xml" `
    -Handlers Lists,Navigation,Features,SiteSettings,ContentTypes,Fields,ComposedLook,CustomActions,SupportedUILanguages,RegionalSettings,SearchSettings `
    -Force
```

**オプション: 基本構造のみの場合**
```powershell
Get-PnPProvisioningTemplate -Out "DevTemplate.xml" `
    -Handlers Lists,Navigation,Features,SiteSettings `
    -Force
```

### Step 3: Prod環境に接続

```powershell
# Prod環境に接続
Connect-PnPOnline -Url "https://cgpinc.sharepoint.com/sites/Test-HubSiteProd" -UseWebLogin
```

### Step 4: テンプレートを適用

```powershell
# テンプレートを適用
Apply-PnPProvisioningTemplate -Path "DevTemplate-Complete.xml"
```

### Step 5: 結果を確認

```powershell
# リストを確認
Get-PnPList | Where-Object { $_.Hidden -eq $false } | Select-Object Title

# ナビゲーションを確認
Get-PnPNavigationNode -Location QuickLaunch | Select-Object Title
```

## 📝 実行結果の例

### 作成されたリスト
- Documents
- Tasks
- Events
- Form Templates
- Site Assets
- Site Pages
- Style Library

### 作成されたナビゲーション
- Home
- Who we are
- What's happening
- Resources
- Smart Guide
- Company Forms
- HR Announcement

## ⚠️ 注意事項

1. **警告メッセージについて**
   - `Style Library is a Style Library of a site with NoScript enabled` - NoScriptモードのため一部機能がスキップされます（正常）
   - `Provisioning of the navigation node failed, retrying` - 一部のナビゲーションノードで再試行が行われます（正常）

2. **ページの手動コピー**
   - ニュースページ等は手動でコピーする必要があります
   - または、ブラウザからページをエクスポート/インポート

3. **ハブナビゲーション**
   - 上部のハブナビゲーションは手動で設定が必要
   - 設定 → Site information → Hub navigation から編集

## 🔄 自動化スクリプト

完全な自動化スクリプトは `build/site-update.ps1` を参照してください。

---

# SharePoint Site Structure Copy - PnP PowerShell Guide

## 📋 Overview

This guide explains how to copy SharePoint site structure from Dev to Prod environment using PnP PowerShell provisioning templates.

## ✅ Elements That Can Be Copied

| Element | Description | Status |
|---------|-------------|--------|
| **Lists** | List structures (Tasks, Documents, etc.) | ✅ Copyable |
| **Navigation** | QuickLaunch (left sidebar) menu | ✅ Copyable |
| **Content Types** | Custom content types | ✅ Copyable |
| **Fields** | Custom column definitions | ✅ Copyable |
| **Site Settings** | Site configuration | ✅ Copyable |
| **Theme/Look** | Theme and appearance settings | ✅ Copyable |
| **Features** | Enabled features | ✅ Copyable |
| **Regional Settings** | Regional and language settings | ✅ Copyable |

## ❌ Elements That Cannot Be Copied

| Element | Description | Reason |
|---------|-------------|--------|
| **Pages** | Site pages (news pages, etc.) | ⚠️ Compatibility issue with legacy PnP |
| **List Data** | Items within lists | Not included by default |
| **Documents** | Files in document libraries | Not included by default |
| **Hub Navigation** | Hub site level navigation | Manual configuration required |
| **Permissions** | Detailed permission settings | Only partially copyable |

### ⚠️ Why Pages Cannot Be Copied

**Technical Limitations:**
- SharePointPnPPowerShellOnline (legacy version) has compatibility issues with modern SharePoint page layouts
- Error: `Input string '1.0' is not a valid integer. Path 'position.sectionIndex'`
- This occurs because page section layout information cannot be parsed correctly

**Workarounds:**
1. Template everything except pages
2. Copy pages manually or export/import separately
3. Consider upgrading to the new PnP.PowerShell module (cross-platform version)

## 🚀 Execution Steps

### Step 1: Connect to Dev Environment

```powershell
# Connect to Dev environment
Connect-PnPOnline -Url "https://cgpinc.sharepoint.com/sites/Test-HubSiteDev" -UseWebLogin
```

### Step 2: Extract Template

```powershell
# Template all structure except pages
Get-PnPProvisioningTemplate -Out "DevTemplate-Complete.xml" `
    -Handlers Lists,Navigation,Features,SiteSettings,ContentTypes,Fields,ComposedLook,CustomActions,SupportedUILanguages,RegionalSettings,SearchSettings `
    -Force
```

**Option: Basic structure only**
```powershell
Get-PnPProvisioningTemplate -Out "DevTemplate.xml" `
    -Handlers Lists,Navigation,Features,SiteSettings `
    -Force
```

### Step 3: Connect to Prod Environment

```powershell
# Connect to Prod environment
Connect-PnPOnline -Url "https://cgpinc.sharepoint.com/sites/Test-HubSiteProd" -UseWebLogin
```

### Step 4: Apply Template

```powershell
# Apply the template
Apply-PnPProvisioningTemplate -Path "DevTemplate-Complete.xml"
```

### Step 5: Verify Results

```powershell
# Check lists
Get-PnPList | Where-Object { $_.Hidden -eq $false } | Select-Object Title

# Check navigation
Get-PnPNavigationNode -Location QuickLaunch | Select-Object Title
```

## 📝 Example Results

### Created Lists
- Documents
- Tasks
- Events
- Form Templates
- Site Assets
- Site Pages
- Style Library

### Created Navigation
- Home
- Who we are
- What's happening
- Resources
- Smart Guide
- Company Forms
- HR Announcement

## ⚠️ Important Notes

1. **About Warning Messages**
   - `Style Library is a Style Library of a site with NoScript enabled` - Some features skipped due to NoScript mode (normal)
   - `Provisioning of the navigation node failed, retrying` - Some navigation nodes will retry (normal)

2. **Manual Page Copying**
   - News pages and other pages must be copied manually
   - Alternatively, export/import pages from browser

3. **Hub Navigation**
   - Top hub navigation must be configured manually
   - Settings → Site information → Hub navigation to edit

## 🔄 Automation Script

For complete automation script, refer to `build/site-update.ps1`.

## 📚 Related Files

- `build/site-build.ps1` - Initial site construction script
- `build/site-update.ps1` - Dev → Prod update script
- `build/create-navigation.ps1` - Navigation creation script
- `templates/DevTemplate.xml` - Basic template
- `templates/DevTemplate-Complete.xml` - Complete template (without pages)

## 🆘 Troubleshooting

### Issue: Connection Error
**Solution:** Ensure you have access permissions to both Dev and Prod sites.

### Issue: Template Extraction Fails
**Solution:** Try excluding Pages handler: `-Handlers Lists,Navigation,Features,SiteSettings`

### Issue: Navigation Not Applied
**Solution:** Some navigation items may be hub-level. Configure manually via Site Settings.

### Issue: Legacy PnP Warning
**Solution:** This is informational. The legacy version still works for most operations.
