{ ... }:
{
  services.wyoming = {
    faster-whisper = {
      servers.default = {
        enable = true;
        device = "cuda";
        uri = "tcp://0.0.0.0:10300";
        language = "en";
        zeroconf = {
          enable = true;
          name = "Faster Whisper Server";
        };
      };
    };
    piper = {
      servers.default = {
        enable = true;
        uri = "tcp://0.0.0.0:10200";
        useCUDA = true;
        voice = "en_US-lessac-medium";
        zeroconf = {
          enable = true;
          name = "Piper Server";
        };
      };
    };
  };
}
