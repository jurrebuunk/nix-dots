{ ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Avoid the X11-bell I/O teardown path that crashed the GDM greeter's
    # PipeWire process. Normal desktop and application audio remain enabled.
    extraConfig.pipewire."10-disable-x11-bell" = {
      "context.properties"."module.x11.bell" = false;
    };
  };
  security.rtkit.enable = true;
}
