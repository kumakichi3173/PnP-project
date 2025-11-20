# PnP PowerShell セットアップガイド

## 使用しているバージョン

**SharePointPnPPowerShellOnline** (旧バージョン)

### なぜ旧バージョンを使用するのか？

- 新しい `PnP.PowerShell` モジュールは PowerShell 7.4.6以上が必要
- PowerShell 7のインストールには管理者権限が必要
- 管理者権限がないため、Windows PowerShell 5.1と互換性のある旧バージョンを使用

## セットアップ手順（初回のみ）

既にインストール済みですが、別の環境で必要な場合：

```powershell
Install-Module -Name "SharePointPnPPowerShellOnline" -Scope CurrentUser -Force -AllowClobber
```

## 毎回の使い方

### 1. モジュールを読み込む

```powershell
Import-Module SharePointPnPPowerShellOnline
```

### 2. コマンド確認（オプション）

```powershell
Get-Command Connect-PnPOnline
```

→ ここで表示されれば OK

### 3. サイトに接続

```powershell
Connect-PnPOnline -Url "https://tenant.sharepoint.com/sites/YourSite" -Interactive
```

## 重要な注意事項

- **PowerShell は セッションごとにモジュールを読み込む必要があります**
- VS Codeで新しいターミナルを開くたびに `Import-Module SharePointPnPPowerShellOnline` を実行してください
- 旧バージョンのため、一部の新機能は使用できない可能性があります