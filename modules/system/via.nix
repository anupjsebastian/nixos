{ pkgs, ... }:

{
  # Enable VIA/QMK support for keyboards
  services.udev.packages = [ pkgs.via ];

  # Add your user to the input group for keyboard access
  users.users.anupjsebastian.extraGroups = [ "input" ];

  # Enable VIA/QMK support
  hardware.keyboard.qmk.enable = true;
}
