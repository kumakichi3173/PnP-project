# Azure DevOps CI/CD セットアップガイド

このプロジェクトは、Azure DevOpsを使用してSharePointサイトの自動デプロイメントを行います。

## 📋 前提条件

- Azure DevOps組織とプロジェクトへのアクセス権限
- SharePoint Dev/Prod環境へのアクセス権限
- サービスプリンシパル（または管理者権限）

---

## 🚀 セットアップ手順

### 1. Azure DevOpsでリポジトリを作成

1. Azure DevOpsにログイン: https://dev.azure.com/
2. プロジェクトを選択または新規作成
3. **Repos** → **Files** → **Import repository**
4. このGitHubリポジトリのURLを入力してインポート

### 2. サービス接続の作成

SharePoint認証用のサービス接続を作成します：

1. **Project Settings** → **Service connections**
2. **New service connection** → **Generic** を選択
3. 以下を設定：
   - **Server URL**: `https://cgpinc.sharepoint.com`
   - **Username**: SharePoint管理者アカウント
   - **Password/Token Key**: パスワードまたはアプリパスワード
   - **Service connection name**: `SharePoint-Connection`

### 3. パイプラインの作成

1. **Pipelines** → **New pipeline**
2. **Azure Repos Git** を選択
3. リポジトリを選択
4. **Existing Azure Pipelines YAML file** を選択
5. パスを指定: `/TestSite/pipelines/azure-pipelines.yml`
6. **Run** をクリック

### 4. 変数の設定（オプション）

パイプライン内の環境URLを変更する場合：

1. パイプラインを開く
2. **Edit** → **Variables**
3. 以下の変数を追加：
   - `devSiteUrl`: Dev環境のURL
   - `prodSiteUrl`: Prod環境のURL

### 5. 環境の作成

デプロイ承認フローを設定する場合：

1. **Pipelines** → **Environments**
2. **New environment** → 名前: `Production`
3. **Approvals and checks** を追加
4. 承認者を設定

---

## 🔄 自動デプロイの動作

### トリガー条件

以下の条件で自動的にパイプラインが実行されます：

- `main`ブランチへのプッシュ
- `templates/DevTemplate.xml`の変更

### デプロイフロー

```
┌─────────────────┐
│  コード変更      │
│  (Dev環境)      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Git Push        │
│ to main branch  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ Azure Pipeline 起動     │
├─────────────────────────┤
│ 1. Dev環境から抽出      │
│ 2. テンプレート生成     │
│ 3. Prod環境に適用       │
└────────┬────────────────┘
         │
         ▼
┌─────────────────┐
│ 承認待ち        │
│ (Production環境) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ デプロイ完了    │
└─────────────────┘
```

---

## 🛠️ ローカル開発での自動化

### オプション1: ファイル監視スクリプト

テンプレートファイルの変更を監視して自動更新：

```powershell
cd TestSite/build
.\watch-and-deploy.ps1
```

### オプション2: VS Code タスク

VS Codeで以下を実行：

1. `Ctrl+Shift+P` → `Tasks: Run Task`
2. **Watch and Deploy** を選択

これにより、バックグラウンドで監視が開始されます。

### オプション3: 手動デプロイ

```powershell
cd TestSite/build
.\site-update.ps1
```

---

## 📝 よくある質問

### Q: パイプラインが失敗します

**A:** 以下を確認してください：
- サービス接続が正しく設定されているか
- SharePoint環境へのアクセス権限があるか
- `SharePointPnPPowerShellOnline`モジュールがインストールされているか

### Q: 承認なしで自動デプロイしたい

**A:** `azure-pipelines.yml`の`environment: 'Production'`を削除してください。

### Q: Dev環境の変更だけで、Prod環境にデプロイしたくない

**A:** ブランチ戦略を変更：
- `dev`ブランチ：Dev環境のみ
- `main`ブランチ：Prod環境にデプロイ

---

## 🔐 セキュリティのベストプラクティス

1. **シークレットの管理**: パスワードは変数グループに保存
2. **承認フロー**: Production環境には承認を設定
3. **最小権限**: サービスアカウントには必要最小限の権限のみ付与
4. **監査ログ**: デプロイ履歴を定期的に確認

---

## 📚 参考リンク

- [Azure Pipelines ドキュメント](https://docs.microsoft.com/azure/devops/pipelines/)
- [PnP PowerShell ドキュメント](https://pnp.github.io/powershell/)
- [SharePoint プロビジョニング](https://docs.microsoft.com/sharepoint/dev/solution-guidance/pnp-provisioning-engine)
