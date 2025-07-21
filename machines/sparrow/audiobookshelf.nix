{...}: {
  services.audiobookshelf = {
    enable = false;
    host = "0.0.0.0";
    port = 8097;
    user = "audiobookshelf";
    group = "audiobookshelf";
  };

  users.users.audiobookshelf.extraGroups = ["jellyfin"];
}
