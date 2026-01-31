{config, pkgs, ...}: {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/bunny@v1.2.0" ];
      hash = "sha256-OkyyPKPKu5C4cASU3r/Uw/vtCVMNRVBnAau4uu+WVp8="; 
    };
    # globalConfig = ''
    # '';
    virtualHosts = {
      "jellyfin.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8096
      '';
      "audiobookshelf.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8097
      '';
      "sabnzbd.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8089
      '';
      "sonarr.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8090
      '';
      "radarr.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8093
      '';
      "prowlarr.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8092
      '';
      "jellyseerr.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8091
      '';
      "immich.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://[::1]:2283
      '';
      "clickhouse.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:9901
      '';
      "chaptarr.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8789
      '';
      "copyparty.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:3923
      '';
      "ha.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        reverse_proxy http://localhost:8123
      '';
      "grocy.echsen.club".extraConfig = ''
        tls {
          dns bunny {env.BUNNY_API_KEY}
        }
        root * ${pkgs.grocy}/public

        # Static File Caching & Security Headers
        @static {
          file
          path *.js *.css *.ttf *.woff *.woff2 *.png *.jpg *.jpeg *.svg
        }
        header @static {
          Cache-Control "public, max-age=15778463"
          X-Content-Type-Options nosniff
          X-Robots-Tag none
          X-Download-Options noopen
          X-Permitted-Cross-Domain-Policies none
          Referrer-Policy no-referrer
        }

        # PHP-FPM handling
        # php_fastcgi handles the try_files, index.php rewrite, and path splitting automatically
        php_fastcgi unix/${config.services.phpfpm.pools.grocy.socket}

        # Serve static files
        file_server
      '';
    };
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = "/var/lib/caddy/bunny.env";
}
