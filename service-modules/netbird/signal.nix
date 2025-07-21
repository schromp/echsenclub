{
  pkgs,
  inputs,
  ...
}: {
  services.netbird.server = {
    signal = {
      enable = true;

      package = inputs.netbird-new-module.legacyPackages.${pkgs.system}.netbird-server;

      port = 8012;
    };
  };
}
