{pkgs, ...}: {
  clan.core.vars.generators = {
    "keycloak-netbird-backend-client-secret" = {
      prompts.keycloak-netbird-backend-client-secret.description = "The zitadel client secret for the netbird user";
      prompts.keycloak-netbird-backend-client-secret.persist = true;

      files.keycloak-netbird-backend-client-secret = {
        secret = true;
      };
    };
  };
}
