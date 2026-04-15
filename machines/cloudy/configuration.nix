{
  pkgs,
  lib,
  ...
}:
{
  clan.core.sops.defaultGroups = [ "admins" ];

  imports = [
    ./disko.nix
    ./keycloak.nix
    ./tangled.nix
    ./grafana.nix
    ./caddy.nix
    # ./jellyswarm.nix
  ];

  fileSystems."/" = {
    device = lib.mkForce "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_59179759-part3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = lib.mkForce "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_59179759-part2";
    fsType = "vfat";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      53
      80
      443
    ];
  };

  services.openssh.settings.PasswordAuthentication = false;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  services.matrix-synapse.settings = {
    max_upload_size = "100M";
  };

  services.resolved.enable = true;
  services.fail2ban.enable = true;
}
