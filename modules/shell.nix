{ config, pkgs, ... }:

{
  # Use zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "eza --icons=always -lh";
      update = "sudo nixos-rebuild switch -I nixos-config=./configuration.nix";
      tree = "eza --tree";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];

    interactiveShellInit = ''
      eval "$(atuin init zsh)"
    '';
  };

  # Set zsh as default
  users.defaultUserShell = pkgs.zsh;
  # update /etc/shells
  environment.shells = with pkgs; [ zsh ];

  # Install atuin package to system and add to path.
  environment.systemPackages = with pkgs; [ atuin ];

  services.atuin = {
    enable = true;
  };


}
