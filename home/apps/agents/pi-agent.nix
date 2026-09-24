{ config, lib, pkgs, ... }:

let
  piToolDisplayPackageSource = "git:github.com/MasuRii/pi-tool-display@91cef7580078371f8dc49a8607222807ad6a424d";
  piMcpAdapterPackageSource = "npm:pi-mcp-adapter";

  codebaseDocsSkill = pkgs.fetchFromGitHub {
    owner = "ekohe";
    repo = "codebase-docs";
    rev = "1045a6f42ce2bd1fc761e96d00a6340cf37213e7";
    hash = "sha256-qzvhtYVe+iezis9OZFA+MSmHYYDI4N/0wHt/8T9+JeU=";
  };

  agentSkills = pkgs.runCommand "pi-agent-skills" { } ''
    cp -R ${./skills} $out
    chmod -R u+w $out
    ln -s ${codebaseDocsSkill} $out/codebase-docs
  '';

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
  home.file.".pi/agent/skills".source = agentSkills;
  home.file.".pi/agent/extensions/pi-a2a-communication".source = piA2ACommunication;

  # Some Pi integrations are Pi packages rather than raw extension sources, so
  # manage them through Pi's package list in settings.json. Pi installs missing
  # packages on startup.
  #
  # - pi-tool-display: compact OpenCode-style tool rendering.
  # - pi-mcp-adapter: third-party MCP bridge used by `/mcp setup` and
  #   `/mcp-auth`, including the Notion MCP setup flow.
  #
  # Also remove any legacy pi-cc-tools package entries so the old tool-collapse /
  # grouped-tool UI extension cannot be loaded again.
  home.activation.piAgentPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings_file="${config.home.homeDirectory}/.pi/agent/settings.json"
    pi_tool_display_package="${piToolDisplayPackageSource}"
    pi_mcp_adapter_package="${piMcpAdapterPackageSource}"

    ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$settings_file")"
    if [ ! -s "$settings_file" ]; then
      printf '{}\n' > "$settings_file"
    fi

    tmp_file="$(${pkgs.coreutils}/bin/mktemp)"
    ${pkgs.jq}/bin/jq \
      --arg piToolDisplayPackage "$pi_tool_display_package" \
      --arg piMcpAdapterPackage "$pi_mcp_adapter_package" '
      def sourceOf: if type == "string" then . else (.source // "") end;
      def isPiCcTools:
        (sourceOf | test("(^git:)?(https://github\\.com/|github\\.com/)FammasMaz/pi-cc-tools(\\.git)?(@.*)?$"));
      def isPiToolDisplay:
        (sourceOf | test("(^git:)?(https://github\\.com/|github\\.com/)MasuRii/pi-tool-display(\\.git)?(@.*)?$"));
      def isPiMcpAdapter:
        (sourceOf | test("^npm:pi-mcp-adapter(@.*)?$"));

      del(
        .toolBackground,
        .readOutputMode,
        .searchOutputMode,
        .mcpOutputMode,
        .previewLines,
        .expandedPreviewMaxLines,
        .extraExpandedPreviewMaxLines,
        .extraToolOutputExpanded,
        .groupToolCalls,
        .bashOutputMode,
        .bashCollapsedLines,
        .liveToolPreview,
        .liveToolPreviewLines,
        .diffCollapsedLines,
        .themeAdaptive,
        .diffTheme,
        .spinnerVerbColor,
        .spinnerStatusColor,
        .toolBranchRgbGray,
        .toolBranchColorMode
      )
      | .packages = (
        ((.packages // []) | map(select((isPiCcTools or isPiToolDisplay or isPiMcpAdapter) | not)))
        + [$piToolDisplayPackage, $piMcpAdapterPackage]
      )
    ' "$settings_file" > "$tmp_file"
    ${pkgs.coreutils}/bin/mv "$tmp_file" "$settings_file"
  '';
}
