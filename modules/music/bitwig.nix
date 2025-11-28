{ unstablePkgs, pkgs, ... }:
{
  # Install Bitwig Studio
  environment.systemPackages = [
    unstablePkgs.bitwig-studio
  ];

  # Ensure proper audio/MIDI support
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
