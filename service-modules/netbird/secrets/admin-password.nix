{pkgs, ...}: {
  clan.core.vars.generators = {
    "netbird-admin-password" = {
      files."password" = {
        secret = true;
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/password
      '';
      share = false;
    };
  };
}
