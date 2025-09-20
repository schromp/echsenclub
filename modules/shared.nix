{
  config,
  clan-core,
  pkgs,
  ...
}:
{
  # Locale service discovery and mDNS
  # services.avahi.enable = false;

  users.users."lk" = {
    isNormalUser = true;
    group = "lk";
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };
  users.groups.lk = { };

  environment.systemPackages = with pkgs; [
    vim
    git
    nettools
  ];

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule

  clan.core.settings.state-version.enable = true;
}
