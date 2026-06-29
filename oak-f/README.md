# oak-f

FTP サーバ `oak-f.co.jp` とのファイル同期用ディレクトリ。

## 事前準備

`rclone config` で `oak-f.co.jp` という名前のリモートを作成しておく。

```sh
rclone config
# n) new remote → 名前: oak-f.co.jp → Storage: ftp → host/user/pass/port 入力
```

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