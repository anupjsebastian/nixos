{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.nerd-fonts.zed-mono
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "ZedMono Nerd Font" ];
      sansSerif = [ "ZedMono Nerd Font" ];
      serif = [ "ZedMono Nerd Font" ];
    };
  };

  # Increase default font size for better readability
  fonts.fontconfig.localConf = ''
    <match target="pattern">
      <test name="family">
        <string>ZedMono Nerd Font</string>
      </test>
      <edit name="pixelsize" mode="assign">
        <double>15</double>
      </edit>
    </match>
  '';
}
