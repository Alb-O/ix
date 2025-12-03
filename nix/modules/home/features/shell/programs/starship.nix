# Shell feature - starship prompt
{ ... }:
{
  enable = true;
  settings = {
    format = "$username$hostname$directory$git_branch$git_status$nix_shell$character";
    character = {
      success_symbol = "[>](green)";
      error_symbol = "[>](red)";
    };
    nix_shell = {
      format = "[$symbol$state]($style) ";
      symbol = "nix ";
    };
  };
}
