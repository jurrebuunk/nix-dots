{ pkgs, ... }:

let
  piA2ACommunication = pkgs.runCommand "pi-a2a-communication-extension" { } ''
    cp -R ${pkgs.fetchFromGitHub {
      owner = "DrOlu";
      repo = "pi-a2a-communication";
      rev = "497ec9fe22620ee51473854cf0d7001cfe409054";
      hash = "sha256-cnccnxwn3/6dbOg+BbQcxPmIIK7kFzclRfvXX7mJJ/s=";
    }} $out
    chmod -R u+w $out

    # pi 0.75 uses session_shutdown for cleanup. The upstream extension uses an
    # older session_end hook name, so patch it while keeping the vendored source
    # otherwise unchanged.
    substituteInPlace $out/index.ts \
      --replace 'pi.on("session_end", async () => {' 'pi.on("session_shutdown", async () => {'
  '';
in
{
  # Pi itself stays normally configured. This module exposes repo-owned skills
  # and a globally auto-discovered extension through Pi's discovery directories.
  home.file.".pi/agent/skills".source = ./skills;
  home.file.".pi/agent/extensions/pi-a2a-communication".source = piA2ACommunication;
}
