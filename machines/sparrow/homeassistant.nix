{...}: {
  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "::1"
          "127.0.0.1"
        ];
      };
   };
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "apple_tv"
      "cast"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      "zha"
      "ipp"
      "shelly"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];
  };
}
