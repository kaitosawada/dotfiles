# oak-f

FTP サーバ `oak-f.co.jp` とのファイル同期用ディレクトリ。

## 事前準備

`rclone config` で `oak-f.co.jp` という名前のリモートを作成しておく。

```sh
rclone config
# n) new remote → 名前: oak-f.co.jp → Storage: sftp (または ftps) → host/user/pass/port 入力
```

> [!NOTE]
> oak-f は個人管理の静的サイト置き場でセキュリティ上の重要度は低い（気にしなくてよい）。
> ただし認証情報が平文で流れる `ftp` は避け、可能な限り `sftp` / `ftps` を使うこと。

## コマンド

```sh
# oak-f.co.jp:/ を oak-f/src/ にダウンロード
make copy

# oak-f/src/ の変更を oak-f.co.jp:/ に同期
make sync

# oak-f/src/ を全削除
make clean
```

## 備考

`src/` は `.gitignore` で除外されているため、リポジトリには含まれない。