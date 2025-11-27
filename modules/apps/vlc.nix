{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    (unstablePkgs.vlc.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        substituteInPlace $out/share/applications/vlc.desktop \
          --replace 'Exec=vlc' 'Exec=env QT_QPA_PLATFORM=wayland vlc'
      '';
    }))
  ];
}
