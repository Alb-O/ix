# Sync feature
# File synchronization with Syncthing
{ imp, ... }:
{
  imports = [ (imp.configTree ./.) ];
}
