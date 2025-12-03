# Shell feature - direnv for per-directory environments
{ ... }:
{
  enable = true;
  enableZshIntegration = true;
  nix-direnv.enable = true;
}
