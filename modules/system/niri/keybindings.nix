{ pkgs, unstablePkgs, ... }:
{
  # Keybindings configuration for niri
  config = ''
    binds {
        // Applications
        Mod+Return { spawn "ptyxis" "--new-window"; }
        Mod+Space { spawn "rofi" "-show" "drun"; }
        Mod+B { spawn "google-chrome-stable"; }
        Mod+T { spawn "ptyxis" "-e" "btop"; }
        Mod+Y { spawn "ptyxis" "-e" "yazi"; }
        Mod+N { spawn "nautilus"; }
        
        Mod+Shift+Slash { show-hotkey-overlay; }
        
        // Window management
        Mod+Q { close-window; }
        
        // Column/Window resizing
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        
        // Screenshots
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
        
        // Window navigation (vim-style)
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }
        
        // Window movement
        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }
        
        // Workspace navigation
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up { focus-workspace-up; }
        
        // Move window to workspace up/down
        Mod+Ctrl+U { move-column-to-workspace-down; }
        Mod+Ctrl+I { move-column-to-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up { move-column-to-workspace-up; }
        
        // Workspace switching
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        
        // Move window to workspace
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        
        // Column width adjustment
        Mod+Comma { set-column-width "-10%"; }
        Mod+Period { set-column-width "+10%"; }
        
        // Consume/expel windows
        Mod+BracketLeft { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        
        // Floating/tiling toggle
        Mod+V { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }
        
        // Center column
        Mod+C { center-column; }
        
        // Overview
        Mod+O { toggle-overview; }
        
        // System
        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
        
        // Volume (will show GNOME OSD)
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        
        // Brightness (will show GNOME OSD)
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
    }
  '';
}
