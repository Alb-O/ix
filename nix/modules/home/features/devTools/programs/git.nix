# Dev tools feature - git version control
{ ... }:
{
  enable = true;

  settings = {
    init.defaultBranch = "main";
    pull.rebase = true;
    push.autoSetupRemote = true;
    alias = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      lg = "log --graph --oneline --decorate";
    };
  };
}
