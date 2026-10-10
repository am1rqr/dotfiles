let icons = import ../icons.nix; in
{
  cpu = {
    format = "${icons.cpu} {usage}%";
    interval = 2;
    tooltip = false;
  };
}
