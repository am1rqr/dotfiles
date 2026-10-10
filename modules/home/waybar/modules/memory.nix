let icons = import ../icons.nix; in
{
  memory = {
    format = "${icons.memory} {}%";
    interval = 2;
    tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
  };
}
