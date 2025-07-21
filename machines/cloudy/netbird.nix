{
  pkgs,
  config,
  inputs,
  ...
}: let
  netbird-domain = "netbird.echsen.club";
in {
  disabledModules = [
    "services/networking/netbird/server.nix"
    "services/networking/netbird/signal.nix"
    "services/networking/netbird/management.nix"
    "services/networking/netbird/dashboard.nix"
    "services/networking/netbird/coturn.nix"
  ];

  imports = [
    # ../../modules/password-turn.nix
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/coturn.nix")
  ];

  services.netbird = {
    server = {
      coturn = {
        enable = true;
        domain = "turn-cloudy.netbird.echsen.club";
        passwordFile = config.clan.core.vars.generators."netbird-turn-cloudy-password".files."turn-cloudy-password".path;
      };
      relay = {
        package = inputs.netbird-new-module.legacyPackages.${pkgs.system}.netbird-server;
        authSecretFile = config.clan.core.vars.generators."netbird-data-store-encryption-key".files."encryption-key".path; # TODO:
      };
      signal = {
        package = inputs.netbird-new-module.legacyPackages.${pkgs.system}.netbird-server;
      };
    };
  };
}
