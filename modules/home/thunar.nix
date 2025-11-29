{ pkgs, ... }:
{
  # Thunar custom actions configuration
  # This manages ~/.config/Thunar/uca.xml
  xdg.configFile."Thunar/uca.xml" = {
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <actions>
      <action>
      	<icon>utilities-terminal</icon>
      	<name>Open Terminal Here</name>
      	<submenu></submenu>
      	<unique-id>1732900000000000-1</unique-id>
      	<command>ptyxis --new-window -d %f</command>
      	<description>Opens a terminal in directory</description>
      	<range></range>
      	<patterns>*</patterns>
      	<startup-notify/>
      	<directories/>
      </action>
      </actions>
    '';
    # Force overwrite any existing config
    force = true;
  };

  # Thunar keyboard shortcuts for custom actions
  # This manages ~/.config/Thunar/accels.scm
  xdg.configFile."Thunar/accels.scm" = {
    text = ''
      ; thunar GtkAccelMap rc-file         -*- scheme -*-
      ; this file is an automated accelerator map dump
      ;
      (gtk_accel_path "<Actions>/ThunarActions/uca-action-1732900000000000-1" "<Primary>period")
    '';
    force = true;
  };
}
