{
  config,
  clan-core,
  pkgs,
  ...
}: {
  # Locale service discovery and mDNS
  services.avahi.enable = true;

  users.users."lk" = {
    isNormalUser = true;
    group = "lk";
  };
  users.groups.lk = {};

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  clan.core.settings.state-version.enable = true;
}
