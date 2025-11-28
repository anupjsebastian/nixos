{
  # Startup applications for niri
  config = ''
    spawn-at-startup "mako"
    spawn-at-startup "waybar"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "waypaper" "--restore"
    spawn-at-startup "sh" "-c" "swaybg -c '#bb9af7'"
    spawn-at-startup "swayidle" "-w" "timeout" "300" "niri msg action power-off-monitors" "resume" "niri msg action power-on-monitors"
  '';
}
