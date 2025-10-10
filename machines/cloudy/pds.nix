{ config, pkgs, ... }:
{

  imports = [
    ../../shared/mail.nix
  ];

  services.bluesky-pds = {
    enable = true;
    settings = {
      PDS_PORT = 3000;
      PDS_HOSTNAME = "pds.echsen.club";
      PDS_INVITE_REQUIRED = "true";
      # PDS_EMAIL_FROM_ADDRESS = "noreply@echsen.club";
    };
    environmentFiles = [
      config.clan.core.vars.generators."pds-env-admin-password".files."pds-env-admin-password".path
      config.clan.core.vars.generators."pds-env-jwt-secret".files."pds-env-jwt-secret".path
      config.clan.core.vars.generators."pds-env-plc-key".files."pds-env-plc-key".path
      # config.clan.core.vars.generators."smtp".files."pds-env-email-url".path
    ];
    pdsadmin = {
      enable = true;
    };
  };

  clan.core.vars.generators = {
    "pds-env-admin-password" = {
      runtimeInputs = with pkgs; [
        coreutils
        openssl
      ];
      script = ''
        ADMIN_PW=$(openssl rand --hex 16)
        echo "PDS_ADMIN_PASSWORD=$ADMIN_PW" > $out/pds-env-admin-password
      '';

      files.pds-env-admin-password = {
        secret = true;
      };
    };

    "pds-env-jwt-secret" = {
      runtimeInputs = with pkgs; [
        coreutils
        openssl
      ];
      script = ''
        JWT_SECRET=$(openssl rand --hex 16)
        echo "PDS_JWT_SECRET=$JWT_SECRET" > $out/pds-env-jwt-secret
      '';

      files.pds-env-jwt-secret = {
        secret = true;
      };
    };
    "pds-env-plc-key" = {
      runtimeInputs = with pkgs; [
        coreutils
        openssl
        unixtools.xxd
      ];
      script = ''
        PLC_KEY=$(openssl ecparam --name secp256k1 --genkey --noout --outform DER | tail --bytes=+8 | head --bytes=32 | xxd --plain --cols 32)
        echo "PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX=$PLC_KEY" > $out/pds-env-plc-key
      '';

      files.pds-env-plc-key = {
        secret = true;
      };
    };
  };
}
