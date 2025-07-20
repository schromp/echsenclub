{pkgs, ...}: {
  services.jellyfin = {
    enable = true;
    dataDir = "/srv/jellyfin";
  };

  environment.systemPackages = with pkgs; [
    jellyfin-ffmpeg
  ];
  # environment.etc = {
  #   "arm" = {
  #     user = "arm";
  #     group = "arm";
  #   };
  #   "arm/arm.yaml".text = ''
  #     ARM_API_KEY: ""
  #   '';
  # };

  # TODO: create /home/arm/config directory
  # TODO: add configuration to here
  # TODO: set permissions for /srv/media

  # Containers
#   virtualisation.oci-containers.containers.arm-ripper = {
#     # user = "arm:arm";
#     pull = "missing";
#     image = "automaticrippingmachine/automatic-ripping-machine:latest";
#     ports = ["28982:8080"];
#     environment = {
#       ARM_UID = "1001";
#       ARM_GID = "1001";
#     };
#     extraOptions = ["--gpus=all"];
#     volumes = [
#       "/home/arm:/home/arm"
#       "/srv/media:/home/arm/media/completed"
#       "/etc/arm/config:/etc/arm/config"
#     ];
#     devices = [
#       "/dev/sr0:/dev/sr0"
#     ];
#     privileged = true;
#     autoStart = true;
#   };
#
#   # In theory this doesnt need a user but ill just use
#   # one so i have a folder on the ssd (overkill ik)
#   users.users.arm = {
#     isNormalUser = true;
#     home = "/home/arm";
#     group = "arm";
#     extraGroups = ["jellyfin"];
#   };
#
#   users.groups.arm = {
#     gid = 1001;
#   };
}
