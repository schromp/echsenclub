{
  pkgs,
  config,
  ...
}: {
  services.k3s = {
    enable = true;
    package = pkgs.k3s_1_33;
    role = "server";
    tokenFile = config.clan.core.vars.generators."k3s-token".files."token".path;
    extraFlags = ["--disable=traefik"]; # This is needed for bare metal nginx to function
  };

  clan.core.vars.generators = {
    "k3s-token" = {
      files."token" = {
        secret = true;
      };
      runtimeInputs = with pkgs; [
        coreutils
        openssl
      ];
      script = ''
        openssl rand -hex 32 > "$out"/token
      '';
    };
  };
}
