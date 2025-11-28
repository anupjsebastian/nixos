{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.nerd-fonts.zed-mono
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "ZedMono Nerd Font Mono" ];
      sansSerif = [ "ZedMono Nerd Font Mono" ];
      serif = [ "ZedMono Nerd Font Mono" ];
    };
  };

  # Increase default font size for better readability
  fonts.fontconfig.localConf = ''
    <match target="pattern">
      <test name="family">
        <string>ZedMono Nerd Font Mono</string>
      </test>
      <edit name="pixelsize" mode="assign">
        <double>16</double>
      </edit>
    </match>
  '';
}
