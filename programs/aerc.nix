{ ... }:
{
  programs.aerc = {
    enable = true;

    extraConfig = {
      general = {
        unsafe-accounts-conf = true;
      };

      ui = {
        mouse-enabled = true;
      };

      filters = {
        "text/plain" = "colorize";
        "text/html" = "html | colorize";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/calendar" = "calendar";
      };
    };
  };

  accounts.email = {
    maildirBasePath = "Mail";

    accounts.personal = {
      primary = true;
      address = "k.sawada@ozonehl.com";
      userName = "k.sawada@ozonehl.com";
      realName = "Kaito Sawada";

      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.gmail.com";
        port = 465;
        tls.enable = true;
      };

      passwordCommand = "bw get notes himalaya-gmail-app-password --session $(cat ~/.bw_session)";

      folders = {
        inbox = "INBOX";
        sent = "[Gmail]/Sent Mail";
        drafts = "[Gmail]/Drafts";
        trash = "[Gmail]/Trash";
      };

      aerc = {
        enable = true;
      };

      himalaya = {
        enable = true;
        settings = {
          # notmuchではなくIMAPバックエンドを使用
          backend.type = "imap";
          backend.host = "imap.gmail.com";
          backend.port = 993;
          backend.encryption.type = "tls";
          backend.login = "k.sawada@ozonehl.com";
          backend.auth.type = "password";
          backend.auth.cmd = "bw get notes himalaya-gmail-app-password --session $(cat ~/.bw_session)";
        };
      };

      mbsync = {
        enable = true;
        create = "maildir";
        patterns = [
          "INBOX"
          "[Gmail]/Sent Mail"
          "[Gmail]/Drafts"
        ];
        extraConfig.account = {
          CertificateFile = "/etc/ssl/cert.pem";
        };
      };

      notmuch = {
        enable = true;
      };
    };
  };

  programs.mbsync = {
    enable = true;
  };
}
