{ pkgs, ... }:
{
  clan.core.vars.generators = {
    "grafana-client-secret" = {
      files = {
        "secret" = {
          secret = true;
          # owner = "authelia-EchsenSSO";
        };
        "hash" = {
          secret = false;
        };
      };
      runtimeInputs = with pkgs; [
        authelia
        gnugrep
      ];
      script = ''
        output=$(authelia crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986)
        password=$(echo "$output" | grep -oP 'Random Password: \K.*')
        hash=$(echo "$output" | grep -oP 'Digest: \K.*')

        {
          printf "GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET=%s\n" "$password"
        } > "$out/secret"

        echo -n "$hash" > "$out/hash"
      '';
      share = true;
    };
  };
}
