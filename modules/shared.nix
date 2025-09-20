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

  clan.core.settings.state-version.enable = true;
}
