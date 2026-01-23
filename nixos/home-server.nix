{ pkgs, config, ... }:
{
  # スリープ/サスペンドを無効化
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # ssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # 公開鍵認証のみ（推奨）
      PermitRootLogin = "no"; # rootログイン禁止（推奨）
    };
  };

  users.users.kaitosawada.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPriyNk0KUYzGZYFxPtpV/BvoKM/Phvc7DvIVjdBuJQX" # ここにBitwardenからコピーした公開鍵
  ];

  # ネットワーク
  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [
      443
    ];
  };

  # ローカルネットワークではcorednsとcaddyを使ってローカル経由で接続
  services.coredns = {
    enable = true;
    config = ''
      . {
        # ローカルオーバーライド
        hosts {
          192.168.11.30 immich.teinei.life
          192.168.11.30 ssh.teinei.life
          192.168.11.30 home.teinei.life
          fallthrough
        }
        
        # 上流に転送
        forward . 1.1.1.1 8.8.8.8
        cache 3600
        log
      }
    '';
  };

  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-dnhEjopeA0UiI+XVYHYpsjcEI6Y1Hacbi28hVKYQURg="; # 初回ビルドでhash取得
    };

    virtualHosts."immich.teinei.life" = {
      extraConfig = ''
        tls {
          dns cloudflare {file.${config.sops.secrets.caddy-cloudflare-token.path}}
        }
        reverse_proxy localhost:2283
      '';
    };

    virtualHosts."home.teinei.life" = {
      extraConfig = ''
        tls {
          dns cloudflare {file.${config.sops.secrets.caddy-cloudflare-token.path}}
        }
        reverse_proxy localhost:8123
      '';
    };
  };

  # 外部からも接続できるようにする
  services.cloudflared = {
    enable = true;
    tunnels = {
      "3f74daeb-ba49-4db4-8ada-b141a013897e" = {
        credentialsFile = "/home/kaitosawada/.cloudflared/3f74daeb-ba49-4db4-8ada-b141a013897e.json";
        default = "http_status:404";
        warp-routing.enabled = true;
        ingress = {
          "ssh.teinei.life" = "ssh://localhost:22";
          "home.teinei.life" = "http://localhost:8123";
          "immich.teinei.life" = "http://localhost:2283";
        };
      };
    };
  };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "switchbot"
      "switchbot_cloud" # 初期設定に必要
      "mobile_app"
    ];
    config = {
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        time_zone = "Asia/Tokyo";
      };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
      default_config = { };
    };
  };

  services.immich = {
    enable = true;
    mediaLocation = "/var/lib/immich";
    host = "0.0.0.0";
    port = 2283;
  };
}
