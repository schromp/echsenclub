{
  pkgs,
  inputs,
  ...
}: {
  services.netbird.server = {
    signal = {
      enable = true;

      package = pkgs.netbird-signal;

      port = 8012;
    };
  };
}
