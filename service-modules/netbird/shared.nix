{inputs, ...}: {
  disabledModules = [
    "services/networking/netbird/server.nix"
    "services/networking/netbird/signal.nix"
    "services/networking/netbird/management.nix"
    "services/networking/netbird/dashboard.nix"
    "services/networking/netbird/coturn.nix"
  ];

  imports = [
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/server.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/dashboard.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/relay.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/signal.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/coturn.nix")
    (inputs.netbird-new-module + "/nixos/modules/services/networking/netbird/proxy.nix")
  ];
}
