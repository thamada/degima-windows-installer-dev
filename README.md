# Development environment for building custom Windows app installers on DEGIMA Cloud

Windows 向けデスクトップアプリのインストーラーを自作するための、Electron ベースの基本的な開発環境です。  
macOS 向けインストーラー（DMG）の作成にも対応しています。

サンプルとして、タブで切り替えられるレトロゲーム（インベーダー・ポン）が同梱されています。アプリ本体やインストーラー設定を差し替えることで、自分用の Windows / macOS アプリをビルドできます。

## 技術スタック

- [Electron](https://www.electronjs.org/) — デスクトップアプリの実行基盤
- [electron-builder](https://www.electron.build/) — インストーラー・配布物の生成
- HTML5 Canvas — サンプルゲームの描画

## ディレクトリ構成

```
degima-windows-installer-dev/
├── Makefile              # 開発・ビルド用（Node.js を .local/ に取得）
├── package.json          # 依存関係・electron-builder 設定
├── src/
│   ├── electron/
│   │   └── main.js       # Electron メインプロセス
│   └── games/
│       ├── index.html    # タブ付きシェル（起動時エントリ）
│       ├── invaders.html # インベーダーゲーム
│       └── pong.html     # ポンゲーム
└── doc/
    ├── design.md         # 設計仕様
    └── ChangeLog.md      # 変更履歴
```

## サンプルアプリ

Electron 起動時は `src/games/index.html` が読み込まれ、画面上部のタブで「インベーダー」と「ポン」を切り替えられます。

| 項目 | 内容 |
|------|------|
| ウィンドウ | 700×580、タイトル「ゲーム」、メニューバー非表示 |
| タブ UI | 高さ 32px のコンパクトなアンダーライン型 |
| ゲーム読み込み | 各ゲームは iframe で分離。ポンは初回タブ選択時に遅延読み込み |
| Canvas | 内部解像度 640×480。CSS でウィンドウ内に自動縮小 |
| スクロール | シェル・各ゲームで `overflow: hidden`、操作キーで `preventDefault()` |

## 前提条件

開発ホスト（`make` を実行するマシン）:

- macOS または Linux（x64 / arm64）
- `make`、`curl` が利用できること

Makefile が Node.js v22.14.0 を `.local/` 以下に自動取得するため、事前に Node.js をインストールする必要はありません。

## 使い方

### 開発（アプリの起動確認）

```bash
make dev
```

Electron ウィンドウが開き、サンプルゲームを操作できます。

### インストーラーのビルド

```bash
make build-win        # Windows ポータブル版 (dist/myapp.exe)
make build-win-nsis   # Windows インストーラー (dist/setup.exe)
make build-mac        # macOS DMG (dist/myapp.dmg)
make build            # 上記 3 つをすべてビルド
```

`dist/` 以下に配布物が出力されます。

| プラットフォーム | 出力ファイル | 説明 |
|------------------|--------------|------|
| Windows (x64) | `dist/myapp.exe` | ポータブル版（インストール不要） |
| Windows (x64) | `dist/setup.exe` | NSIS インストーラー（インストール先変更可） |
| macOS | `dist/myapp.dmg` | DMG イメージ（Intel / Apple Silicon） |

> Windows 向けの EXE は、macOS や Linux 上の `electron-builder` からクロスビルドされます。  
> 初回ビルド時は依存ツールのダウンロードに時間がかかることがあります。

### クリーンアップ

```bash
make clean
```

`.local/`、`node_modules/`、`dist/`、`build/` を削除します。

## カスタマイズの入口

自分のアプリに差し替える際は、主に次のファイルを編集します。

| ファイル | 内容 |
|----------|------|
| `src/electron/main.js` | ウィンドウサイズ・タイトル・読み込む HTML のパス |
| `src/games/index.html` | タブ付きシェル（タブ数・レイアウト） |
| `src/games/` | アプリの UI（サンプルゲームを置き換え） |
| `package.json` の `build` セクション | アプリ ID、製品名、インストーラー種別、出力ファイル名 |

詳細な設計は [doc/design.md](doc/design.md)、変更履歴は [doc/ChangeLog.md](doc/ChangeLog.md) を参照してください。

## npm スクリプト（参考）

Makefile を使わない場合は、Node.js を用意したうえで次のコマンドでも同等の操作ができます。

```bash
npm install
npm start               # 開発起動
npm run build:win       # Windows ポータブル版
npm run build:win-nsis  # Windows インストーラー
npm run build:mac       # macOS DMG
```

## ライセンス

Apache-2.0（[LICENSE](LICENSE)）
