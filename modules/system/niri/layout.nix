{
  # Window layout configuration for niri
  config = ''
    layout {
        gaps 8
        center-focused-column "on-overflow"
            
            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            default-column-width { proportion 0.5; }
            
            focus-ring {
                width 2
                active-color "#7aa2f7"
                inactive-color "#3b4261"
            }
            
            border {
                width 2
                active-color "#7aa2f7"
                inactive-color "#3b4261"
            }
        }

        prefer-no-csd

        window-rule {
            geometry-corner-radius 8
            clip-to-geometry true
        }
  '';
}
