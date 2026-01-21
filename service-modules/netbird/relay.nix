{pkgs, config, inputs, ...}: {
  services.netbird.server = {
    relay = {
      enable = true;

      package = pkgs.netbird-relay.overrideAttrs (oldAttrs: rec {
        version = "0.64.0";
        src = oldAttrs.src.override {
          tag = "v${version}";
          hash = "sha256-3E8kdSJLturNxUoG66LxqWudVTGOObLtimmdoKZiKPs=";
        };
        vendorHash = "sha256-LeY6bnn3aZdG+NeVlvzByvump03A6GhGJW4Bld2bGoc=";
      });

      port = 33080;
      authSecretFile = config.clan.core.vars.generators."netbird-relay-auth".files."password".path;

      settings = {
        NB_EXPOSED_ADDRESS = "rel://netbird.echsen.club:443";
        NB_STUN_PORT = "3478";
        NB_ENABLE_STUN = "true";
      };
    };
  };
}
