{
  pkgs,
  inputs,
  ...
}: {
  services.netbird.server = {
    signal = {
      enable = true;

      package = pkgs.netbird-signal.overrideAttrs (oldAttrs: rec {
        version = "0.64.0";
        src = oldAttrs.src.override {
          tag = "v${version}";
          hash = "sha256-3E8kdSJLturNxUoG66LxqWudVTGOObLtimmdoKZiKPs=";
        };
        vendorHash = "sha256-LeY6bnn3aZdG+NeVlvzByvump03A6GhGJW4Bld2bGoc=";
      });

      port = 8012;
    };
  };
}
