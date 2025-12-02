{ ... }:
{
  enable = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -la";
    ".." = "cd ..";
    "..." = "cd ../..";
    g = "git";
    nrs = "sudo nixos-rebuild switch --flake .";
    hms = "home-manager switch --flake .";
  };

  history = {
    size = 10000;
    save = 10000;
    share = true;
    ignoreDups = true;
  };

  initContent = ''
    # Custom zsh initialization
    bindkey -e  # Emacs keybindings
  '';
}
