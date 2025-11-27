{ unstablePkgs, pkgs, ... }:
let
  bitwig-wrapped = pkgs.symlinkJoin {
    name = "bitwig-studio-wrapped";
    paths = [ unstablePkgs.bitwig-studio ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/bitwig-studio \
        --set GDK_BACKEND x11 \
        --set GDK_SCALE 1 \
        --set GDK_DPI_SCALE 1 \
        --set QT_AUTO_SCREEN_SCALE_FACTOR 0 \
        --set QT_SCALE_FACTOR 1
    '';
  };
in
{
  environment.systemPackages = [
    bitwig-wrapped
  ];
}
