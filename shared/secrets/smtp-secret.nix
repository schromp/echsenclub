{ ... }:
{
  users.groups."smtp-secret" = { };

  clan.core.vars.generators = {
    "smtp-secret" = {
      prompts = {
        username = {
          description = "The username for the SMTP server";
          type = "line";
          persist = true;
        };
        password = {
          description = "The password for the SMTP server";
          type = "hidden";
          persist = true;
        };
      };
      files."username" = {
        secret = false;
        group = "smtp-secret";
      };
      files."password" = {
        secret = true;
        mode = "0440";
        group = "smtp-secret";
      };
    };
  };
}
