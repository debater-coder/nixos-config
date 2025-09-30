{lib, config, ...}:
with lib;
let cfg = config.myHomeManager.shell; in {
  options.myHomeManager.shell = {
    enable = mkEnableOption "Enable zsh configuration";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        update = "sudo nixos-rebuild switch --flake ~/nixos#starscream";
        test-update = "sudo nixos-rebuild test --flake ~/nixos#starscream";
        lg = "lazygit";
      };
    };

    programs.starship = {
      enable = true;
    };
    programs.atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "fuzzy";
      };
    };
  };
}
