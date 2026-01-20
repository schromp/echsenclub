{...}: {
  virtualisation.oci-containers.containers."chaptarr" = {
    image = "robertlordhood/chaptarr:latest";
    autoStart = true;
    
    # Mapping the 8789:8789 port
    # ports = [ "8789:8789" ];

    environment = {
      PUID = "2000";
      PGID = "66000";
      TZ = "US/Eastern";
      # Uncomment and set these if you decide to use an external DB
      # Chaptarr__Postgres__Host = "your-db-host";
      # Chaptarr__Postgres__User = "user";
    };

    volumes = [
      # Note: NixOS usually prefers absolute paths for host volumes
      "/var/lib/chaptarr/config:/config"
      "bookstest:/srv/media/books_chaptarr"
      "/srv/media/audiobooks_chaptarr:/audiobooks"
      "downloads:/downloads"
      "/var/lib/sabnzbd/Downloads/complete:/var/lib/sabnzbd/Downloads/complete"
    ];

    extraOptions = [ "--network=host" ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/chaptarr/config 0750 2000 66000 - -"
  ];
}
