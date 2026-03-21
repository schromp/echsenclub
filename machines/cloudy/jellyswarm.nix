{inputs, pkgs, config, lib, ...}: {
  imports = [
    inputs.jellyswarm.nixosModules.default
  ];

  services.jellyswarrm = {
    enable = true;
    package = inputs.jellyswarm.packages.${pkgs.system}.default.overrideAttrs 
      (finalAttrs: previousAttrs: {      
        version = "0.2.1";
        src = pkgs.fetchFromGitHub {
          owner = "LLukas22";
          repo = "Jellyswarrm";
          rev = "v0.2.1";
          sha256 = "sha256-bf+HiZLS54abDV9wW/MZQT/UJrtUQMlmFcmN+5T2FYU=";
        };
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = finalAttrs.src + "/Cargo.lock";
          allowBuiltinFetchGit = true;
        };
        cargoHash = null;
      });
    host = "127.0.0.1";
    port = 3030;
    username = "admin";
    passwordFile = config.clan.core.vars.generators."jellyswarm-admin-password".files."password".path;
    extraEnvironment = {
      JELLYSWARM_SERVER_NAME = "Echsflix";
      JELLYSWARM_INCLUDE_SERVER_NAME_IN_MEDIA = "true";
      JELLYSWARRM_PUBLIC_ADDRESS = "flix.echsen.club";
      # JELLYSWARRM_PRECONFIGURED_SERVERS = [];
    };
  };

  clan.core.vars.generators = {
    "jellyswarm-admin-password" = {
      files."password" = {
        secret = true;
      };
      runtimeInputs = with pkgs; [
        openssl
      ];
      script = ''
        openssl rand -base64 32 > $out/password
      '';
      share = false;
    };
  };
  
}
