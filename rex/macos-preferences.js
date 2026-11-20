// Run with macOS osascript. Set individual preferences so other Rex settings survive.
ObjC.import("Foundation");

function run() {
  const prefs = $.NSUserDefaults.alloc.initWithSuiteName("com.superlogical.rex");
  const settings = {
    // Classic with theme tint, following the system light/dark appearance.
    appearance: "system",
    interfaceStyle: "useTheme",
    tabStyle: "horizontal",
    sidebarPosition: "left",
    toolbarBehavior: "alwaysShow",
    paneDensity: "compact",
    showsPaneHeaders: false,
    paneHeaderVisibility: "onHover",
    showsActivePaneBorder: true,
    activePaneBorderColor: "yellow", // SubMonokai renders ANSI yellow as orange.
    activePaneBorderOpacity: 0.1,
    activePaneBorderTransition: "move",
    inactivePaneFadeMode: "styling", // Surface in Rex Settings.
    usesStandardInactiveWindowPaneStyles: false,
    sidebarTextPointSize: 15,
    preservesWindowWidthOnSidebarToggle: true,
    sidebarSwipe: "swipe",
    usesGestures: true,
    animationStyle: "snappy",

    lightThemeID: "merino-light",
    lightUsesExtendedThemePalette: true,
    darkUsesExtendedThemePalette: true,

    terminalFontName: "SauceCodePro Nerd Font Mono",
    terminalFontPointSize: 16,
    terminalSmoothScrolling: true,
    smoothResizeEnabled: true,
    terminalCopyOnSelect: true,
    terminalCopyAnimation: true,
    terminalSelectionRoundedCorners: true,
    cursorShadersEnabled: true,
    cursorShader: "warp",
  };

  const data = prefs.dataForKey("Workspace.customThemes");
  if (data && !data.isNil()) {
    const json = $.NSString.alloc.initWithDataEncoding(data, $.NSUTF8StringEncoding);
    const themes = JSON.parse(ObjC.unwrap(json));
    const active = ObjC.unwrap(prefs.stringForKey("Workspace.darkThemeID"));
    const matches = themes.filter(theme => theme.name === "SubMonokai" && theme.appearance === "dark");
    const selected = matches.find(theme => theme.id === active) || matches[0];
    if (selected) settings.darkThemeID = selected.id;
  }

  for (const [key, value] of Object.entries(settings)) {
    prefs.setObjectForKey($(value), "Workspace." + key);
  }
  // Theme selection colors are represented by the absence of custom overrides.
  prefs.removeObjectForKey("Workspace.terminalSelectionForeground");
  prefs.removeObjectForKey("Workspace.terminalSelectionBackground");
  if (!prefs.synchronize) throw new Error("Could not save Rex preferences.");
  if (!settings.darkThemeID) {
    return "In Rex, use Import Theme File and select ~/dotfiles/submonokai/SubMonokai.ghostty.";
  }
}
