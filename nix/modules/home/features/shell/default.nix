# Shell feature
# A complete interactive shell: zsh, starship prompt, fzf, direnv
{ imp, ... }:
{
  imports = [ (imp.configTree ./.) ];
}
