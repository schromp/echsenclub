{...}: {
  services.authelia.instances."EchsenSSO" = {
    enable = true;
    name = "EchsenSSO";
    settings = {
      authentication_backend = {
        ldap = {
          address = "ldap://127.0.0.1:3890";
          implementation = "lldap";
          base_dn = "dc=echsen,dc=club";
          user = "UID=authelia,OU=people,DC=echsen,DC=club";        
        };
      };
    };
    secrets = {
      storageEncryptionKeyFile = "";
      sessionSecretFile = "";
      oidcIssuerPrivateKeyFile = "";
      oidcHmacSecretFile = "";
      jwtSecretFile = "";
    };
  };
}
