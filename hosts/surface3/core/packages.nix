{ pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.nano.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    vscode
    curl
    wget
    htop
    unzip
    zip
    file
    pciutils
    usbutils
  ];
  environment.variables.EDITOR = "nano";
  fonts.packages = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts-color-emoji
  ];
}
