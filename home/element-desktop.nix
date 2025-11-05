{ config, pkgs, ... }:

# NOT FINISHED DOESNT WORK YET

{
  # Ensure Element Desktop is installed
  home.packages = with pkgs; [
    element-desktop
  ];

  # Manage the Element config file declaratively
  home.file.".config/Element/config.json".text = builtins.toJSON {
    settingDefaults = {
      custom_themes = [
        {
          name = "Gruvbox Dark";
          is_dark = true;
          colors = {
            accent-color = "#bd93f9";
            primary-color = "#fe8019";
            warning-color = "#fb4934";
            sidebar-color = "#282828";
            roomlist-background-color = "#1d2021";
            roomlist-text-color = "#a89984";
            roomlist-text-secondary-color = "#00ff00";
            roomlist-highlights-color = "#00000030";
            roomlist-separator-color = "#4d4d4d90";
            timeline-background-color = "#000000";
            timeline-text-color = "#ebdbb2";
            secondary-content = "#928374";
            tertiary-content = "#928374";
            quinary-content = "#504945";
            timeline-text-secondary-color = "#a89984";
            timeline-highlights-color = "#00000030";
            reaction-row-button-selected-bg-color = "#689d6a";
            menu-selected-color = "#504945";
            icon-button-color = "#928374";
            accent = "#689d6a";
            alert = "#cc241d";
            username-colors = [
              "#cc241d"
              "#98971a"
              "#d79921"
              "#458588"
              "#b16286"
              "#689d6a"
              "#a89984"
              "#d65d0e"
            ];
            avatar-background-colors = [
              "#458588"
              "#b16286"
              "#689d6a"
            ];
          };
        }
      ];
    };

    # Enable Labs settings
    show_labs_settings = true;
  };
}
