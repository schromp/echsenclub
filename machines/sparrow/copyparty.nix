{config, inputs, ...}: {

  imports = [
    inputs.copyparty.nixosModules.default
  ];

  services.copyparty = {
    enable = true;
    settings = {};
    accounts = {
      schromp.passwordFile = config.clan.core.vars.generators."copyparty-schromp".files."password".path;
    };
    volumes = {
      "/" = {
        path = "/srv/copyparty";
        access = {
          r = "*";
          rw = "schromp";
        };
        flags = {
          # "fk" enables filekeys (necessary for upget permission) (4 chars long)
          fk = 4;
          # scan for new files every 60sec
          scan = 60;
          # volflag "e2d" enables the uploads database
          e2d = true;
          # "d2t" disables multimedia parsers (in case the uploads are malicious)
          d2t = true;
          # skips hashing file contents if path matches *.iso
          nohash = "\.iso$";
        };
      };
    };
  };

  clan.core.vars.generators = {
    "copyparty-schromp" = {
      prompts.password.description = "Password for schromp";
      prompts.password.persist = true;
      prompts.password.type = "hidden";

      files.password = {
        secret = true;
        owner = "copyparty";
        group = "copyparty";
      };
    };
  };
}
