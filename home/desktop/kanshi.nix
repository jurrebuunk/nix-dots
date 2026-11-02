{ ... }:

{
  services.kanshi = {
    enable = true;

    settings = [
      {
        profile.name = "ultrawide_only";
        profile.outputs = [
          { criteria = "LG Electronics LG ULTRAWIDE 0x000591DF"; position = "0,0"; status = "enable"; }
          { criteria = "eDP-1"; status = "disable"; }
        ];
      }
      {
        profile.name = "laptop_only";
        profile.outputs = [
          { criteria = "eDP-1"; status = "enable"; }
        ];
      }
    ];
  };
}
