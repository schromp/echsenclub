{config, ...}: {
  services.maubot = {
    enable = true;
    plugins = with config.services.maubot.package.plugins; [
      echo
      (webhook.override {
        base_config = {
          path = "/send";
          method = "POST";
          room = "!AAAAAAAAAAAAAAAAAA:example.com";
          message = "Hello world!";
          message_format = "plaintext";
          message_type = "m.text";
          auth_type = "";
          auth_token = "";
          force_json = false;
          ignore_empty_messages = false;
        };
      })
    ];
    settings = {
      server = {
        port = 29316;
        public_url = "https://maubot.echsen.club";
        # ui_base_path = "_matrix/maubot";
      };
      homeservers = {
        "echsen.club" = {
          url = "https://matrix.echsen.club";
        };
      };
      admins = {
        schromp = "1234";
      };
    };
  };
}
