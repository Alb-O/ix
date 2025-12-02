{ ... }:
{
  enable = true;

  settings = {
    user = {
      name = "Alice";
      email = "alice@example.com";
    };
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
