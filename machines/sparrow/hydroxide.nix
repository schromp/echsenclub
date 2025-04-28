{pkgs, ...}: {
  clan.core.vars.generators = {
    "hydroxide" = {
      prompts.hydroxide-username.description = "The protonmail username";
      prompts.hydroxide-username.persist = true;

      prompts.hydroxide-bridge-pw.description = "The hyrdoxide bridge password";
      prompts.hydroxide-bridge-pw.persist = false;

      script = ''
        echo $prompts/hydroxide-username > $out/hydrooxide-username
        echo $prompts/hydroxide-bridge-pw > $out/hydroxide-bridge-pw

        cat > "$out/hydroxide-zitadel-secret" <<EOF
        SMTPConfiguration:
          SMTP:
            Password: $(cat "$prompts/hydroxide-bridge-pw")
        EOF
      '';

      files.hydroxide-bridge-pw = {
        secret = false;
      };

      files.hydroxide-username = {
        secret = false;
      };

      files.hydroxide-zitadel-secret = {
        secret = false; # FIX: but its hard because of the zitadel user
      };
    };
  };

  users.users.hydroxide = {
    isSystemUser = true;
    createHome = false;
    home = "/var/lib/hydroxide";
    group = "hydroxide";
  };
  users.groups.hydroxide = {};

  # WARN: Hydroxide needs to manually be authenticated because that is not scriptable
  # sudo -u hydroxide HOME=/var/lib/hydroxide /nix/store/xc84ay9fgiybz1ybylw268mdsllgmn7c-hydroxide-0.2.29/bin/hydroxide auth name
  # Get the store path from the systemd file
  systemd.services.hydroxide-smtp = {
    description = "Hydroxide SMTP service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      User = "hydroxide";
      Group = "hydroxide";
      WorkingDirectory = "/var/lib/hydroxide";

      ExecStart = "${pkgs.hydroxide}/bin/hydroxide smtp";
      Restart = "on-failure";

      # Security hardening
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ReadWritePaths = ["/var/lib/hydroxide"];
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/hydroxide 0750 hydroxide hydroxide -"
  ];
}
