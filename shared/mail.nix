{pkgs, ...}: {
  clan.core.vars.generators = {
    "smtp" = {
      prompts.url = {
        description = "The URL of the SMTP server";
        type = "line";
        persist = false;
      };

      prompts.port = {
        description = "The port of the SMTP server";
        type = "line";
        persist = false;
      };

      prompts.username = {
        description = "The username of the SMTP account";
        type = "line";
        persist = false;
      };

      prompts.password = {
        description = "The password of the SMTP account";
        type = "hidden";
        persist = false;
      };

      runtimeInputs = with pkgs; [
        coreutils
        openssl
        urlencode
      ];
      script = ''
        printf "PDS_EMAIL_SMTP_URL=smtps://%s:%s@%s:%s" \
          "$(cat "$prompts/username" | urlencode)" \
          "$(cat "$prompts/password" | urlencode)" \
          "$(cat "$prompts/url")" \
          "$(cat "$prompts/port")" \
          > "$out/pds-env-email-url"
      '';

      files.pds-env-email-url = {
        secret = true;
      };
      share = true;
    };
  };
}
