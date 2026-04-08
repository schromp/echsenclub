{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    port = 11434;
    host = "0.0.0.0";
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
    };
  };

  services.open-webui = {
    enable = true;
    port = 11435;
  };
}
