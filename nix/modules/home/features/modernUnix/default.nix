# Modern Unix feature
# Modern replacements for classic Unix tools
{ imp, ... }:
{
  imports = [ (imp.configTree ./.) ];
}
