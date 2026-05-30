{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: {
  home.packages = [
    pkgs.wechat
    pkgs-unstable.feishu
    pkgs.obsidian
    pkgs.gthumb
  ];

  imports = [
    inputs.niri.homeModules.niri
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.vicinae.homeManagerModules.default
  ];
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      spawn-at-startup = [
        {argv = ["vicinae" "server"];}
      ];
      outputs = {
        "DP-1" = {
          scale = 1.5;
          mode = {
            width = 3840;
            height = 2160;
            refresh = 170.0;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        "DP-2" = {
          scale = 1.5;
          mode = {
            width = 3840;
            height = 2160;
            refresh = 170.0;
          };
          position = {
            x = 2560;
            y = 0;
          };
        };
        "HDMI-A-1" = {
          scale = 1;
          mode = {
            width = 1920;
            height = 1080;
            refresh = 59.950;
          };
          position = {
            x = 320;
            y = 1440;
          };
        };
      };
      layout = {
        border = {
          enable = false;
        };
      };
      window-rules = [
        {
          matches = [
            {
              app-id = "^chrome-blgdilankhbcpipclgpdndahbehalgkh-.*$";
            }
            {
              app-id = "^chrome-cinhimbnkkaeohfgghhklpknlkffjgod-.*$";
            }
          ];
          open-on-output = "DP-2";
        }
        {
          matches = [
            {
              app-id = "^com\\.mitchellh\\.ghostty$";
            }
            {
              app-id = "^org\\.gnome\\.Nautilus$";
            }
          ];
          open-floating = true;
          default-column-width.fixed = 2000;
          default-window-height.fixed = 1000;
        }
      ];
    };
  };
  programs.dank-material-shell = {
    dgop.package = pkgs-unstable.dgop;
    enable = true;
    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
    };
    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = false; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableClipboardPaste = true; # Pasting items from the clipboard (wtype)
    settings = {
      greeterWallpaperPath = "/home/maji/Pictures/wallhaven-7jwz59.jpg";
      currentThemeName = "purple";
      currentThemeCategory = "generic";
      customThemeFile = "";
      registryThemeVariants = {};
      matugenScheme = "scheme-tonal-spot";
      runUserMatugenTemplates = true;
      matugenTargetMonitor = "";
      popupTransparency = 1;
      dockTransparency = 1;
      widgetBackgroundColor = "sch";
      widgetColorMode = "default";
      controlCenterTileColorMode = "primary";
      buttonColorMode = "primary";
      cornerRadius = 12;
      nirilayoutgapsoverride = -1;
      nirilayoutradiusoverride = -1;
      nirilayoutbordersize = -1;
      ue24hourclock = true;
      showseconds = false;
      padhours12hour = false;
      usefahrenheit = false;
      windspeedunit = "kmh";
      nightmodeenabled = false;
      animationspeed = 1;
      customanimationduration = 500;
      synccomponentanimationspeeds = true;
      popoutanimationspeed = 1;
      popoutcustomanimationduration = 150;
      modalanimationspeed = 1;
      modalcustomanimationduration = 150;
      enablerippleeffects = true;
      blurenabled = false;
      blurforegroundlayers = true;
      blurlayeroutlineopacity = 0.12;
      blurbordercolor = "outline";
      blurbordercustomcolor = "#ffffff";
      blurborderopacity = 0.35;
      wallpaperfillmode = "fill";
      blurredwallpaperlayer = false;
      blurwallpaperonoverview = false;
      showlauncherbutton = true;
      showworkspaceswitcher = true;
      showfocusedwindow = true;
      showweather = true;
      showmusic = true;
      showclipboard = true;
      showcpuusage = true;
      showmemusage = true;
      showcputemp = true;
      showgputemp = true;
      selectedgpuindex = 0;
      enabledgpupciids = ["0000:02:00.0"];
      showsystemtray = true;
      systemtrayicontintmode = "none";
      systemtrayicontintsaturation = 50;
      systemtrayicontintstrength = 135;
      showclock = true;
      shownotificationbutton = true;
      showbattery = true;
      showcontrolcenterbutton = true;
      showcapslockindicator = true;
      controlcentershownetworkicon = true;
      controlcentershowbluetoothicon = true;
      controlcentershowaudioicon = true;
      controlcentershowaudiopercent = false;
      controlcentershowvpnicon = true;
      controlcentershowbrightnessicon = false;
      controlcentershowbrightnesspercent = false;
      controlcentershowmicicon = false;
      controlcentershowmicpercent = false;
      controlcentershowbatteryicon = false;
      controlcentershowprintericon = false;
      controlcentershowscreensharingicon = true;
      showprivacybutton = true;
      privacyshowmicicon = false;
      privacyshowcameraicon = false;
      privacyshowscreenshareicon = false;
      controlcenterwidgets = [
        {
          id = "volumeslider";
          enabled = true;
          width = 50;
        }
        {
          id = "brightnessslider";
          enabled = true;
          width = 50;
        }
        {
          id = "wifi";
          enabled = true;
          width = 50;
        }
        {
          id = "bluetooth";
          enabled = true;
          width = 50;
        }
        {
          id = "audiooutput";
          enabled = true;
          width = 50;
        }
        {
          id = "audioinput";
          enabled = true;
          width = 50;
        }
        {
          id = "nightmode";
          enabled = true;
          width = 50;
        }
        {
          id = "darkmode";
          enabled = true;
          width = 50;
        }
      ];
      showworkspaceindex = false;
      showworkspacename = false;
      showworkspacepadding = false;
      workspacescrolling = false;
      showworkspaceapps = false;
      maxworkspaceicons = 5;
      workspaceappiconsizeoffset = 0;
      groupworkspaceapps = true;
      workspacefollowfocus = false;
      showoccupiedworkspacesonly = false;
      reversescrolling = false;
      dwlshowalltags = false;
      workspacecolormode = "default";
      workspaceoccupiedcolormode = "none";
      workspaceunfocusedcolormode = "default";
      workspaceurgentcolormode = "default";
      workspacefocusedborderenabled = false;
      workspacefocusedbordercolor = "primary";
      workspacefocusedborderthickness = 2;
      workspacenameicons = {};
      waveprogressenabled = true;
      scrolltitleenabled = true;
      audiovisualizerenabled = true;
      audioscrollmode = "volume";
      audiowheelscrollamount = 5;
      clockcompactmode = false;
      focusedwindowcompactmode = false;
      runningappscompactmode = true;
      barmaxvisibleapps = 0;
      barmaxvisiblerunningapps = 0;
      barshowoverflowbadge = true;
      appsdockhideindicators = false;
      appsdockcolorizeactive = false;
      appsdockactivecolormode = "primary";
      appsdockenlargeonhover = false;
      appsdockenlargepercentage = 125;
      appsdockiconsizepercentage = 100;
      keyboardlayoutnamecompactmode = false;
      runningappscurrentworkspace = true;
      runningappsgroupbyapp = false;
      runningappscurrentmonitor = false;
      appidsubstitutions = [
        {
          pattern = "spotify";
          replacement = "spotify";
          type = "exact";
        }
        {
          pattern = "beepertexts";
          replacement = "beeper";
          type = "exact";
        }
        {
          pattern = "home assistant desktop";
          replacement = "homeassistant-desktop";
          type = "exact";
        }
        {
          pattern = "com.transmissionbt.transmission";
          replacement = "transmission-gtk";
          type = "contains";
        }
        {
          pattern = "^steam_app_(\\d+)$";
          replacement = "steam_icon_$1";
          type = "regex";
        }
      ];
      centeringmode = "index";
      clockdateformat = "";
      lockdateformat = "";
      greeterrememberlastsession = true;
      greeterrememberlastuser = true;
      greeterenablefprint = false;
      greeterenableu2f = false;
      greeterwallpaperpath = "/home/maji/pictures/wallhaven-7jwz59.jpg";
      mediasize = 1;
      applauncherviewmode = "list";
      spotlightmodalviewmode = "list";
      browserpickerviewmode = "grid";
      browserusagehistory = {};
      apppickerviewmode = "grid";
      filepickerusagehistory = {};
      sortappsalphabetically = false;
      applaunchergridcolumns = 4;
      spotlightclosenirioverview = true;
      spotlightsectionviewmodes = {};
      appdrawersectionviewmodes = {};
      nirioverviewoverlayenabled = true;
      danklauncherv2size = "compact";
      danklauncherv2borderenabled = false;
      danklauncherv2borderthickness = 2;
      danklauncherv2bordercolor = "primary";
      dankLauncherV2ShowFooter = true;
      dankLauncherV2UnloadOnClose = false;
      useAutoLocation = false;
      weatherEnabled = true;
      networkPreference = "auto";
      iconTheme = "System Default";
      cursorSettings = {
        theme = "System Default";
        size = 24;
        niri = {
          hideWhenTyping = false;
          hideAfterInactiveMs = 0;
        };
        hyprland = {
          hideOnKeyPress = false;
          hideOnTouch = false;
          inactiveTimeout = 0;
        };
        dwl = {
          cursorHideTimeout = 0;
        };
      };
      launcherLogoMode = "apps";
      launcherLogoCustomPath = "";
      launcherLogoColorOverride = "";
      launcherLogoColorInvertOnMode = false;
      launcherLogoBrightness = 0.5;
      launcherLogoContrast = 1;
      launcherLogoSizeOffset = 0;
      fontFamily = "Inter Variable";
      monoFontFamily = "Hack Nerd Font";
      fontWeight = 400;
      fontScale = 1;
      notepadUseMonospace = true;
      notepadFontFamily = "";
      notepadFontSize = 14;
      notepadShowLineNumbers = false;
      notepadTransparencyOverride = -1;
      notepadLastCustomTransparency = 0.7;
      soundsEnabled = true;
      useSystemSoundTheme = false;
      soundNewNotification = true;
      soundVolumeChanged = true;
      soundPluggedIn = true;
      acMonitorTimeout = 900;
      acLockTimeout = 600;
      acSuspendTimeout = 0;
      acSuspendBehavior = 0;
      acProfileName = "";
      batteryMonitorTimeout = 0;
      batteryLockTimeout = 0;
      batterySuspendTimeout = 0;
      batterySuspendBehavior = 0;
      batteryProfileName = "";
      batteryChargeLimit = 100;
      lockBeforeSuspend = false;
      loginctlLockIntegration = true;
      fadeToLockEnabled = true;
      fadeToLockGracePeriod = 5;
      fadeToDpmsEnabled = true;
      fadeToDpmsGracePeriod = 5;
      launchPrefix = "";
      brightnessDevicePins = {};
      wifiNetworkPins = {};
      bluetoothDevicePins = {};
      audioInputDevicePins = {};
      audioOutputDevicePins = {};
      gtkThemingEnabled = false;
      qtThemingEnabled = false;
      syncModeWithPortal = true;
      terminalsAlwaysDark = false;
      muxType = "tmux";
      muxUseCustomCommand = false;
      muxCustomCommand = "";
      muxSessionFilter = "";
      runDmsMatugenTemplates = true;
      matugenTemplateGtk = true;
      matugenTemplateNiri = true;
      matugenTemplateHyprland = true;
      matugenTemplateMangowc = true;
      matugenTemplateQt5ct = true;
      matugenTemplateQt6ct = true;
      matugenTemplateFirefox = true;
      matugenTemplatePywalfox = true;
      matugenTemplateZenBrowser = true;
      matugenTemplateVesktop = true;
      matugenTemplateEquibop = true;
      matugenTemplateGhostty = true;
      matugenTemplateKitty = true;
      matugenTemplateFoot = true;
      matugenTemplateAlacritty = true;
      matugenTemplateNeovim = false;
      matugenTemplateWezterm = true;
      matugenTemplateDgop = true;
      matugenTemplateKcolorscheme = true;
      matugenTemplateVscode = true;
      matugenTemplateEmacs = true;
      matugenTemplateZed = true;
      showDock = false;
      dockAutoHide = false;
      dockSmartAutoHide = false;
      dockGroupByApp = false;
      dockOpenOnOverview = false;
      dockPosition = 1;
      dockSpacing = 4;
      dockBottomGap = 0;
      dockMargin = 0;
      dockIconSize = 40;
      dockIndicatorStyle = "circle";
      dockBorderEnabled = false;
      dockBorderColor = "surfaceText";
      dockBorderOpacity = 1;
      dockBorderThickness = 1;
      dockIsolateDisplays = false;
      dockLauncherEnabled = false;
      dockLauncherLogoMode = "apps";
      dockLauncherLogoCustomPath = "";
      dockLauncherLogoColorOverride = "";
      dockLauncherLogoSizeOffset = 0;
      dockLauncherLogoBrightness = 0.5;
      dockLauncherLogoContrast = 1;
      dockMaxVisibleApps = 0;
      dockMaxVisibleRunningApps = 0;
      dockShowOverflowBadge = true;
      notificationOverlayEnabled = false;
      notificationPopupShadowEnabled = true;
      notificationPopupPrivacyMode = false;
      modalDarkenBackground = true;
      lockScreenShowPowerActions = true;
      lockScreenShowSystemIcons = true;
      lockScreenShowTime = true;
      lockScreenShowDate = true;
      lockScreenShowProfileImage = true;
      lockScreenShowPasswordField = true;
      lockScreenShowMediaPlayer = true;
      lockScreenPowerOffMonitorsOnLock = false;
      lockAtStartup = false;
      enableFprint = false;
      maxFprintTries = 15;
      enableU2f = false;
      u2fMode = "or";
      lockScreenActiveMonitor = "all";
      lockScreenInactiveColor = "#000000";
      lockScreenNotificationMode = 0;
      hideBrightnessSlider = false;
      notificationTimeoutLow = 5000;
      notificationTimeoutNormal = 5000;
      notificationTimeoutCritical = 0;
      notificationCompactMode = false;
      notificationPopupPosition = 0;
      notificationAnimationSpeed = 1;
      notificationCustomAnimationDuration = 400;
      notificationHistoryEnabled = true;
      notificationHistoryMaxCount = 50;
      notificationHistoryMaxAgeDays = 7;
      notificationHistorySaveLow = true;
      notificationHistorySaveNormal = true;
      notificationHistorySaveCritical = true;
      notificationRules = [];
      osdAlwaysShowValue = false;
      osdPosition = 5;
      osdVolumeEnabled = true;
      osdMediaVolumeEnabled = true;
      osdMediaPlaybackEnabled = false;
      osdBrightnessEnabled = true;
      osdIdleInhibitorEnabled = true;
      osdMicMuteEnabled = true;
      osdCapsLockEnabled = true;
      osdPowerProfileEnabled = false;
      osdAudioOutputEnabled = true;
      powerActionConfirm = true;
      powerActionHoldDuration = 0.5;
      powerMenuActions = [
        "reboot"
        "logout"
        "poweroff"
        "lock"
        "suspend"
        "restart"
      ];
      powerMenuDefaultAction = "logout";
      powerMenuGridLayout = false;
      customPowerActionLock = "";
      customPowerActionLogout = "";
      customPowerActionSuspend = "";
      customPowerActionHibernate = "";
      customPowerActionReboot = "";
      customPowerActionPowerOff = "";
      updaterHideWidget = false;
      updaterUseCustomCommand = false;
      updaterCustomCommand = "";
      updaterTerminalAdditionalParams = "";
      displayNameMode = "system";
      screenPreferences = {};
      showOnLastDisplay = {};
      niriOutputSettings = {};
      hyprlandOutputSettings = {};
      displayProfiles = {};
      activeDisplayProfile = {};
      displayProfileAutoSelect = false;
      displayShowDisconnected = false;
      displaySnapToEdge = true;
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [
            {
              name = "DP-1";
              model = "P275MV MAX";
            }
          ];
          showOnLastDisplay = false;
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
          ];
          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];
          rightWidgets = [
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "battery"
            "controlCenterButton"
          ];
          spacing = 4;
          innerPadding = 4;
          bottomGap = 0;
          transparency = 0;
          widgetTransparency = 0.4;
          squareCorners = false;
          noBackground = false;
          maximizeWidgetIcons = false;
          maximizeWidgetText = false;
          removeWidgetPadding = false;
          widgetPadding = 8;
          gothCornersEnabled = false;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          borderEnabled = false;
          borderColor = "surfaceText";
          borderOpacity = 1;
          borderThickness = 1;
          widgetOutlineEnabled = false;
          widgetOutlineColor = "primary";
          widgetOutlineOpacity = 1;
          widgetOutlineThickness = 1;
          fontScale = 1;
          iconScale = 1;
          autoHide = false;
          autoHideDelay = 250;
          showOnWindowsOpen = false;
          openOnOverview = false;
          visible = true;
          popupGapsAuto = true;
          popupGapsManual = 4;
          maximizeDetection = true;
          scrollEnabled = true;
          scrollXBehavior = "column";
          scrollYBehavior = "workspace";
          shadowIntensity = 0;
          shadowOpacity = 60;
          shadowColorMode = "text";
          shadowCustomColor = "#000000";
          clickThrough = false;
        }
      ];
      desktopClockEnabled = false;
      desktopClockStyle = "analog";
      desktopClockTransparency = 0.8;
      desktopClockColorMode = "primary";
      desktopClockCustomColor = {
        r = 1;
        g = 1;
        b = 1;
        a = 1;
        hsvHue = -1;
        hsvSaturation = 0;
        hsvValue = 1;
        hslHue = -1;
        hslSaturation = 0;
        hslLightness = 1;
        valid = true;
      };
      desktopClockShowDate = true;
      desktopClockShowAnalogNumbers = false;
      desktopClockShowAnalogSeconds = true;
      desktopClockX = -1;
      desktopClockY = -1;
      desktopClockWidth = 280;
      desktopClockHeight = 180;
      desktopClockDisplayPreferences = [
        "all"
      ];
      systemMonitorEnabled = false;
      systemMonitorShowHeader = true;
      systemMonitorTransparency = 0.8;
      systemMonitorColorMode = "primary";
      systemMonitorCustomColor = {
        r = 1;
        g = 1;
        b = 1;
        a = 1;
        hsvHue = -1;
        hsvSaturation = 0;
        hsvValue = 1;
        hslHue = -1;
        hslSaturation = 0;
        hslLightness = 1;
        valid = true;
      };
      systemMonitorShowCpu = true;
      systemMonitorShowCpuGraph = true;
      systemMonitorShowCpuTemp = true;
      systemMonitorShowGpuTemp = true;
      systemMonitorGpuPciId = "0000:02:00.0";
      systemMonitorShowMemory = true;
      systemMonitorShowMemoryGraph = true;
      systemMonitorShowNetwork = true;
      systemMonitorShowNetworkGraph = true;
      systemMonitorShowDisk = true;
      systemMonitorShowTopProcesses = false;
      systemMonitorTopProcessCount = 3;
      systemMonitorTopProcessSortBy = "cpu";
      systemMonitorGraphInterval = 60;
      systemMonitorLayoutMode = "auto";
      systemMonitorX = -1;
      systemMonitorY = -1;
      systemMonitorWidth = 320;
      systemMonitorHeight = 480;
      systemMonitorDisplayPreferences = [
        "all"
      ];
      systemMonitorVariants = [];
      desktopWidgetPositions = {};
      desktopWidgetGridSettings = {};
      desktopWidgetInstances = [];
      desktopWidgetGroups = [];
      builtInPluginSettings = {};
      clipboardEnterToPaste = false;
      launcherPluginVisibility = {};
      launcherPluginOrder = [];
      configVersion = 5;
    };
    session = {
      isLightMode = true;
      # Add any other session state settings here
      wallpaperPath = "/home/maji/Pictures/wallhaven-7jwz59.jpg";
      weatherLocaltion = "New York, NY";
      weatherCoordinates = "33.996,116.481";
      nvidiaGpuTempEnabled = true;
      nonNvidiaGpuTempEnabled = true;
    };
    clipboardSettings = {
      maxHistory = 25;
      maxEntrySize = 5242880;
      autoClearDays = 1;
      clearAtStartup = true;
      disabled = false;
      disableHistory = false;
      disablePersist = true;
    };
    niri = {
      enableKeybinds = false; # Sets static preset keybinds
      enableSpawn = false; # Auto-start DMS with niri, if enabled
      includes = {
        enable = true; # Enable config includes hack. Enabled by default.

        override = true; # If disabled, DMS settings won't be prioritized over settings defined using niri-flake
        originalFileName = "hm"; # A new name (without extension) for the config file generated by niri-flake.
        filesToInclude = [
          # Files under `$XDG_CONFIG_HOME/niri/dms` to be included into the new config
          "alttab" # Please note that niri will throw an error if any of these files are missing.
          "binds"
          "colors"
          "layout"
          "outputs"
          "wpblur"
        ];
      };
    };
  };
  services.vicinae = {
    enable = true;

    systemd = {
      enable = true;
      autoStart = true;

      environment = {
        USE_LAYER_SHELL = 1;
      };
    };

    # settings = {
    #   close_on_focus_loss = true;
    #   consider_preedit = true;
    #   pop_to_root_on_close = true;
    #
    #   launcher_window = {
    #     opacity = 0.98;
    #   };
    # };
  };
  home.file.".config/DankMaterialShell/avatar.png".source = /home/maji/Pictures/jp.png;
  home.activation.setDmsAvatar = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if command -v dms >/dev/null 2>&1; then
      if systemctl --user is-active --quiet dms.service; then
        dms ipc call profile setImage "$HOME/.config/DankMaterialShell/avatar.png" || true
      fi
    fi
  '';
  # xdg.configFile."niri/dms/binds.kdl".text = ''
  #   binds {
  #     Mod+Return {
  #       spawn "foot";
  #     }
  #   }
  # '';
}
