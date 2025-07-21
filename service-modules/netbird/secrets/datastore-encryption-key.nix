{pkgs, ...}: {
  clan.core.vars.generators = {
    "netbird-data-store-encryption-key" = {
      files."encryption-key" = {
        secret = true;
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out-server/encryption-key
      '';
    };
  };
}
