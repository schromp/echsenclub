{...}: {
  services.audiobookshelf = {
    enable = true;
    port = 8097;
    user = "audiobookshelf";
    group = "media";
  };

  users.users.audiobookshelf.extraGroups = ["jellyfin"];
}
