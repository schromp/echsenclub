{
  pkgs,
  inputs,
  ...
}: {
  services.netbird.server = {
    signal = {
      enable = true;

      package = pkgs.netbird-signal.overrideAttrs (oldAttrs: rec {
        version = "0.63.0";
        src = oldAttrs.src.override {
          tag = "v${version}";
          hash = "sha256-PNxwbqehDtBNKkoR5MtnmW49AYC+RdiXpImGGeO/TPg=";
        };
        vendorHash = "sha256-iTfwu6CsYQYwyfCax2y/DbMFsnfGZE7TlWE/0Fokvy4=";
      });

      port = 8012;
    };
  };
}
