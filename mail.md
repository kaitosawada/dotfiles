# メール

- tui: aerc
- メール同期: mbsync -a
- メール検索：notmuch

## mbsync例

```sh
mbsync -a
```

```sh
mbsync personal:INBOX
```

## notmuch例

```sh
notmuch tag +unread and tag:inbox
```

```shsh
notmuch search --output=files tag:inbox and tag:unread
```

```sh
notmuch show tag:inbox and tag:unread
```
