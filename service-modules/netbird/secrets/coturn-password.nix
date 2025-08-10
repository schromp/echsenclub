{pkgs, ...}: {
  clan.core.vars.generators = {
    "coturn-password" = {
      files."password" = {
        secret = true;
        group = "turnserver";
        mode = "0440";
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/password
      '';

      share = true;
    };
  };
}
