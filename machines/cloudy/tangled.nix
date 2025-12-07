{ inputs, ... }:
{
  imports = [
    inputs.tangled.nixosModules.knot
    inputs.tangled.nixosModules.spindle
  ];

  services.tangled.knot = {
    enable = true;
    gitUser = "git";
    openFirewall = false;
    motd = ''
      Yarrr write some code
    '';
    server = {
      owner = "did:plc:ltd46vfzdow3gesucfihrqc2";
      hostname = "knot.echsen.club";
    };
  };

  services.tangled.spindle = {
    enable = true;

    server = {
      hostname = "spindle.echsen.club";
      owner = "did:plc:ltd46vfzdow3gesucfihrqc2";
    };
  };
}
