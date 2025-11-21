# TestSite Project

SharePoint Online サイト構築・デプロイメントプロジェクト

## プロジェクト構造

```
TESTSITE/
│
├── build/                  # ビルド・デプロイスクリプト
│   ├── site-build.ps1      # サイト初期構築スクリプト
│   └── site-update.ps1     # Dev → Prod 更新スクリプト
│
├── docs/                   # ドキュメント
│   ├── Report.docx         # プロジェクトレポート
│   └── README.md           # このファイル
│
├── templates/              # PnP プロビジョニングテンプレート
│   └── DevTemplate.xml     # Dev環境テンプレート
│
└── pipelines/              # Azure DevOps パイプライン設定
    └── azure-pipelines.yml # CI/CD パイプライン定義
```

## 使用方法

### 1. Dev環境でサイトを構築

```powershell
cd build
.\site-build.ps1
```

### 2. Dev → Prod に更新を適用

```powershell
cd build
.\site-update.ps1
```

### 3. Azure DevOps自動デプロイ

`pipelines/azure-pipelines.yml` をAzure DevOpsリポジトリに設定すると、
mainブランチへのコミット時に自動的にDev→Prodデプロイが実行されます。

## 環境

- **Dev**: https://cgpinc.sharepoint.com/sites/CaitacApps-TheHubSiteDev
- **Prod**: https://cgpinc.sharepoint.com/sites/CaitacApps-TheHubSiteProd

## PnP PowerShell セットアップ

### 使用しているバージョン

**SharePointPnPPowerShellOnline** (旧バージョン)

### セットアップ手順（初回のみ）

```powershell
Install-Module -Name "SharePointPnPPowerShellOnline" -Scope CurrentUser -Force -AllowClobber
```

### 毎回の使い方

```powershell
# 1. モジュールを読み込む
Import-Module SharePointPnPPowerShellOnline

# 2. サイトに接続
Connect-PnPOnline -Url "https://cgpinc.sharepoint.com/sites/CaitacApps-TheHubSiteDev" -UseWebLogin
```

### 注意事項

- PowerShellセッションごとにモジュールを読み込む必要があります
- VS Codeで新しいターミナルを開くたびに `Import-Module` を実行してください
