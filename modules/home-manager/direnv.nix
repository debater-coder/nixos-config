{lib, config, ...}:
with lib;
let cfg = config.myHomeManager.direnv; in {
  options.myHomeManager.direnv = {
    enable = mkEnableOption "Enable direnv configuration";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
