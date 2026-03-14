{ pkgs, ... }:
{
  clan.core.vars.generators = {
    "netbird-client-secret" = {
      files = {
        "netbird-client-secret" = {
          secret = true;
          owner = "authelia-EchsenSSO";
        };
        "netbird-client-hash" = {
          secret = false;
          owner = "authelia-EchsenSSO";
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
        echo -n "$password" > "$out/netbird-client-secret"
        echo -n "$hash" > "$out/netbird-client-hash"
      '';
      share = true;
    };
  };
}
