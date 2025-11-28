{
  # Input configuration (keyboard, mouse, touchpad, gestures) for niri
  config = ''
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        
        touchpad {
            tap
            natural-scroll
            accel-speed 0.3
        }
        
        mouse {
            accel-speed 0.2
        }
        
        disable-power-key-handling
    }

    // Disable hot corners
    gestures {
        hot-corners {
            off
        }
    }
  '';
}
