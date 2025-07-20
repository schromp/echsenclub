{
  config,
  clan-core,
  pkgs,
  ...
}: {
  # Locale service discovery and mDNS
  services.avahi.enable = true;

  # generate a random password for our user below
  # can be read using `clan secrets get <machine-name>-user-password` command
  users.users.user = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
    ];
    uid = 1000;
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  clan.core.settings.state-version.enable = true;
}
