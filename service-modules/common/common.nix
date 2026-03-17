{
  _class = "clan.service";
  manifest.name = "common";
  manifest.readme = builtins.readFile ./README.md;

  roles.default = {
    description = "Common configuration for all machines, e.g., packages, timezone, and nix optimisations.";
    perInstance =
      {
        ...
      }:
      {
        nixosModule =
          { pkgs, ... }:
          {
            environment.systemPackages = with pkgs; [
              vim
              git
              net-tools
              dnslookup
              ghostty.terminfo
            ];

            nix = {
              optimise = {
                automatic = true;
                dates = [ "03:45" ];
              };
              gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 30d";
              };
            };

            time.timeZone = "Europe/Berlin";
          };
      };
  };
}
