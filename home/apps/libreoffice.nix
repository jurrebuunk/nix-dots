{ pkgs, theme, ... }:

{
  # Install LibreOffice with all language support
  home.packages = with pkgs; [
    libreoffice-fresh
  ];

  # Configure LibreOffice to look and feel like Windows Office
  home.file.".config/libreoffice/4/user/registrymodifications.xcu" = {
    force = true;
    text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      
      <!-- Enable Tabbed/Notebookbar UI (like Office Ribbon) -->
      <item oor:path="/org.openoffice.Office.UI.GlobalSettings/Toolbars"><prop oor:name="Mode" oor:op="fuse"><value>notebookbar</value></prop></item>
      
      <!-- Use Tabbed Compact variant (most Office-like) -->
      <item oor:path="/org.openoffice.Office.UI.Writer/Notebookbar"><prop oor:name="Active" oor:op="fuse"><value>notebookbar_compact.ui</value></prop></item>
      <item oor:path="/org.openoffice.Office.UI.Calc/Notebookbar"><prop oor:name="Active" oor:op="fuse"><value>notebookbar_compact.ui</value></prop></item>
      <item oor:path="/org.openoffice.Office.UI.Impress/Notebookbar"><prop oor:name="Active" oor:op="fuse"><value>notebookbar_compact.ui</value></prop></item>
      <item oor:path="/org.openoffice.Office.UI.Draw/Notebookbar"><prop oor:name="Active" oor:op="fuse"><value>notebookbar_compact.ui</value></prop></item>
      
      <!-- Use Colibre icon theme (modern, Office-like) -->
      <item oor:path="/org.openoffice.Office.Common/Misc"><prop oor:name="SymbolStyle" oor:op="fuse"><value>colibre</value></prop></item>
      
      <!-- Enable smooth scrolling -->
      <item oor:path="/org.openoffice.Office.Common/View"><prop oor:name="SmoothScroll" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Use hardware acceleration -->
      <item oor:path="/org.openoffice.Office.Common/VCL"><prop oor:name="UseOpenGL" oor:op="fuse"><value>true</value></prop></item>
      <item oor:path="/org.openoffice.Office.Common/VCL"><prop oor:name="ForceSkia" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Enable font anti-aliasing -->
      <item oor:path="/org.openoffice.Office.Common/Font"><prop oor:name="FontAntiAliasingMinPixelHeight" oor:op="fuse"><value>8</value></prop></item>
      
      <!-- Set default fonts to match Office -->
      <item oor:path="/org.openoffice.Office.Common/Font/SourceViewFont"><prop oor:name="FontName" oor:op="fuse"><value>${theme.fonts.serif}</value></prop></item>
      <item oor:path="/org.openoffice.Office.Common/Font/SourceViewFont"><prop oor:name="FontHeight" oor:op="fuse"><value>${toString theme.fonts.sizes.document}</value></prop></item>
      
      <!-- Enable recent documents in start center -->
      <item oor:path="/org.openoffice.Office.Common/History"><prop oor:name="PickListSize" oor:op="fuse"><value>25</value></prop></item>
      
      <!-- Show tip of the day (like Office) -->
      <!-- Disable tip of the day -->
      <item oor:path="/org.openoffice.Office.Common/Misc"><prop oor:name="ShowTipOfTheDay" oor:op="fuse"><value>false</value></prop></item>

      <!-- Disable First Start Wizard -->
      <item oor:path="/org.openoffice.Setup/Office"><prop oor:name="FirstStartWizardCompleted" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Enable experimental features for better compatibility -->
      <item oor:path="/org.openoffice.Office.Common/Misc"><prop oor:name="ExperimentalMode" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Writer: Enable formatting marks button -->
      <item oor:path="/org.openoffice.Office.Writer/Content/NonprintingCharacter"><prop oor:name="ParagraphEnd" oor:op="fuse"><value>false</value></prop></item>
      
      <!-- Writer: Use Microsoft Word compatible settings -->
      <item oor:path="/org.openoffice.Office.Writer/Compatibility"><prop oor:name="AddParaSpacingToTableCells" oor:op="fuse"><value>true</value></prop></item>
      <item oor:path="/org.openoffice.Office.Writer/Compatibility"><prop oor:name="UseOldNumbering" oor:op="fuse"><value>false</value></prop></item>
      
      <!-- Calc: Use Excel-compatible function names -->
      <item oor:path="/org.openoffice.Office.Calc/Formula/Syntax"><prop oor:name="Grammar" oor:op="fuse"><value>1</value></prop></item>
      
      <!-- Enable AutoCorrect (like Office) -->
      <item oor:path="/org.openoffice.Office.Common/AutoCorrect"><prop oor:name="UseReplacementTable" oor:op="fuse"><value>true</value></prop></item>
      <item oor:path="/org.openoffice.Office.Common/AutoCorrect"><prop oor:name="TwoCapitalsAtStart" oor:op="fuse"><value>true</value></prop></item>
      <item oor:path="/org.openoffice.Office.Common/AutoCorrect"><prop oor:name="CapitalAtStartSentence" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Set default save format to Microsoft Office formats -->
      <item oor:path="/org.openoffice.Office.Common/Filter/Microsoft/Import"><prop oor:name="WinWordToWriter" oor:op="fuse"><value>true</value></prop></item>
      <item oor:path="/org.openoffice.Office.Common/Filter/Microsoft/Import"><prop oor:name="ExcelToCalc" oor:op="fuse"><value>true</value></prop></item>
      <item oor:path="/org.openoffice.Office.Common/Filter/Microsoft/Import"><prop oor:name="PowerPointToImpress" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Default to DOCX/XLSX/PPTX for saving -->
      <item oor:path="/org.openoffice.Office.Common/Save/Document"><prop oor:name="WarnAlienFormat" oor:op="fuse"><value>false</value></prop></item>
      
      <!-- Enable sidebar (like Office task panes) -->
      <item oor:path="/org.openoffice.Office.UI.Sidebar"><prop oor:name="IsSidebarVisible" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Use single toolbar mode -->
      <item oor:path="/org.openoffice.Office.UI.GlobalSettings/Toolbars"><prop oor:name="LockToolbars" oor:op="fuse"><value>false</value></prop></item>
      
      <!-- Enable live preview for formatting -->
      <item oor:path="/org.openoffice.Office.Common/Misc"><prop oor:name="LivePreview" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Disable splash screen for faster startup -->
      <item oor:path="/org.openoffice.Office.Common/Misc"><prop oor:name="UseSystemFileDialog" oor:op="fuse"><value>true</value></prop></item>
      
      <!-- Enable macro security (medium level like Office) -->
      <item oor:path="/org.openoffice.Office.Common/Security/Scripting"><prop oor:name="MacroSecurityLevel" oor:op="fuse"><value>2</value></prop></item>
      
      <!-- Enable undo with large step count -->
      <item oor:path="/org.openoffice.Office.Common/Undo"><prop oor:name="Steps" oor:op="fuse"><value>100</value></prop></item>
      
      <!-- Use Windows-style keyboard shortcuts -->
      <item oor:path="/org.openoffice.Office.Common/View"><prop oor:name="NewDocumentHandling" oor:op="fuse"><value>0</value></prop></item>
      
    </oor:items>
  '';
  };

  # Additional LibreOffice configuration
  home.file.".config/libreoffice/4/user/autocorr/acor_en-US.dat".source = 
    "${pkgs.libreoffice-fresh}/lib/libreoffice/share/autocorr/acor_en-US.dat";
}
