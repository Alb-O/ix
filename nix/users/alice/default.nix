{
  imp,
  registry,
  ...
}:
{
  imports = [
    # Home features (each feature uses configTree internally)
    (import registry.modules.home.features.shell)
    (import registry.modules.home.features.devTools)
    (import registry.modules.home.features.modernUnix)
    (import registry.modules.home.features.sync)
  ];

  # User-specific git config (overrides devTools defaults)
  programs.git.settings.user = {
    name = "Alice";
    email = "alice@example.com";
  };

  home = {
    username = "alice";
    homeDirectory = "/home/alice";
    stateVersion = "24.05";
  };

  xdg.enable = true;
}
