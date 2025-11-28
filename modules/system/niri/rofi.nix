{
  # Rofi theme configuration
  theme = ''
    configuration {
        modi: "drun,run,window";
        show-icons: true;
        drun-display-format: "{name}";
        font: "ZedMono Nerd Font 12";
    }

    @theme "/dev/null"

    * {
        bg: #1a1b26;
        bg-alt: #24283b;
        fg: #c0caf5;
        fg-alt: #a9b1d6;
        
        accent: #7aa2f7;
        urgent: #f7768e;
        
        background-color: transparent;
        text-color: @fg;
        
        margin: 0;
        padding: 0;
        spacing: 0;
    }

    window {
        background-color: @bg;
        border: 2px;
        border-color: @accent;
        border-radius: 12px;
        width: 500px;
        padding: 16px;
    }

    mainbox {
        children: [inputbar, listview];
        spacing: 16px;
    }

    inputbar {
        children: [entry];
        background-color: @bg-alt;
        border-radius: 8px;
        padding: 12px;
    }

    entry {
        placeholder: "";
    }

    listview {
        lines: 8;
        scrollbar: false;
    }

    element {
        padding: 8px 12px;
        border-radius: 6px;
    }

    element selected {
        background-color: @accent;
        text-color: @bg;
    }

    element-icon {
        size: 20px;
        margin: 0 12px 0 0;
    }

    element-text {
        vertical-align: 0.5;
    }
  '';
}
