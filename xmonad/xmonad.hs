--------------------------------------------------------------------------------
-- ~/.xmonad/xmonad.hs
{-# LANGUAGE NoMonomorphismRestriction #-}
--------------------------------------------------------------------------------
import XMonad
import XMonad.Hooks.EwmhDesktops
import System.Exit
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive (setOpacity)
import Data.List (isInfixOf, isSuffixOf)
--import XMonad.Hooks.FadeWindows
import XMonad.Layout.Circle
import XMonad.Layout.ToggleLayouts
import XMonad.Prompt
import XMonad.Prompt.Shell   
import Data.Monoid
import XMonad.Prompt.AppendFile
import XMonad.Prompt.Ssh
import XMonad.Hooks.ManageDocks
import XMonad.ManageHook
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Layout.IndependentScreens
import XMonad.Layout.IM
import Data.Ratio ((%))
import XMonad.Layout.Grid
import XMonad.Layout.Reflect
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import XMonad.Layout.ResizableTile
import XMonad.Util.NamedScratchpad 
import XMonad.Util.Run
import XMonad.Layout.Accordion
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicHooks
import XMonad.Actions.SpawnOn
import XMonad.Layout.LayoutHints
import XMonad.Actions.CycleWS
import Data.Char (ord)
import Data.List (elemIndex)
import Data.Function (on)
import XMonad.Util.WorkspaceCompare
import qualified Solarized.Light as S



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


scratchpads = [ NS "screen"   spawnScreen  findScreen   manageScreen
              , NS "calc"     spawnCalc    findCalc     manageCalc
              , NS "clock"    spawnClock   findClock    manageClock
              , NS "scribble" spawnXournal findXournal  manageXournal
              ]
  where
    spawnScreen  = myTerminal ++ " -name scratchpad -e screen -c ~/.screen/configs/scratchpad -S scratchpad -D -R scratchpad screen"
    findScreen   = resource =? "scratchpad"
    manageScreen = customFloating $ W.RationalRect l t w h
      where
        h = 0.4
        w = 0.8
        t = (1 - h) / 2
        l = (1 - w) / 2
    
    spawnCalc  = myTerminal ++ " -name calc -e R --vanilla"
    findCalc   = resource =? "calc"
    manageCalc = customFloating $ W.RationalRect l t w h
      where
        h = 0.4
        w = 0.8
        t = (1 - h) / 2
        l = (1 - w) / 2

    spawnClock = myTerminal ++ " -name clock -e tty-clock -scC1"
    findClock = resource =? "clock"
    manageClock = customFloating $ W.RationalRect l t w h
      where
        h = 0.3
        w = 1
        t = (1 - h) / 2
        l = 0

    spawnXournal  = "xournal --role scribble /home/cgie/notes.xoj"
    findXournal   = role =? "scribble"
      where role = stringProperty "WM_WINDOW_ROLE"
    manageXournal = customFloating $ W.RationalRect l t w h
      where
        h = 1
        w = 1
        t = (1 - h) / 2
        l = (1 - w) / 2

-- main
main = do
  nScreens <- countScreens
--  handles  <- mapM (spawnPipe . xmobarCommand) [0 .. nScreens-1]
  handles <- mapM (spawnPipe . dzenCommand) [1 .. nScreens]
--  dzen     <- spawnPipe myStatusBar
--  dzenright <- spawnPipe myStatusBarRight
--  mpdbar <- spawn myMPDBar
--  clockbar <- spawn myClockBar
--  mailbar <- spawn myMailBar
--  statebar <- spawn myStateBar
  xmonad $ myUrgencyHook $ defaultConfig
    { terminal           = myTerminal
    , focusFollowsMouse  = myFocusFollowsMouse
    , borderWidth        = myBorderWidth
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
    , layoutHook         = myLayouts
    , handleEventHook    = handleEventHook defaultConfig <+> fullscreenEventHook
    , manageHook         = myManageHook  <+> manageSpawn <+> manageDocks <+> dynamicMasterHook
    , logHook            = mapM_ dynamicLogWithPP $ zipWith myDzenPP handles [0..nScreens-1] -- >> (fadeInactiveLogHook 0.9)
    , startupHook        = myStartupHook
    }
--------------------------------------------------------------------------------
-- Color and font definitions:
--myFont = "-*-montecarlo-medium-r-normal-*-11-*-*-*-c-*-*-*"
myFont = "inconsolata:pixelsize=18:antialias=true:hinting=true"
myIconDir = "/home/cgie/usr/share/dzen_bitmaps"
--myDzenFGColor = "#dcdccc"
--myDzenBGColor = "#3f3f3f"
myDzenFGColor = "#657b83"
myDzenBGColor = "#eee8d5"
myNormalFGColor = "#657b83"
myNormalBGColor = "#eee8d5"
myFocusedFGColor = "#000000"
myFocusedBGColor = "#93a1a1"
myUrgentFGColor = "#eee8d5"
myUrgentBGColor = "#506070"
myIconFGColor = "#87AF87"
myIconBGColor = "#3f3f3f"
mySeperatorColor = "#555555"
-- from https://github.com/ibotty/solarized-xmonad/blob/master/Solarized.hs
solarizedBase03  = "#002b36"
solarizedBase02  = "#073642"
solarizedBase01  = "#586e75"
solarizedBase00  = "#657b83"
solarizedBase0   = "#839496"
solarizedBase1   = "#93a1a1"
solarizedBase2   = "#eee8d5"
solarizedBase3   = "#fdf6e3"
solarizedYellow  = "#b58900"
solarizedOrange  = "#cb4b16"
solarizedRed     = "#dc322f"
solarizedMagenta = "#d33682"
solarizedViolet  = "#6c71c4"
solarizedBlue    = "#268bd2"
solarizedCyan    = "#2aa198"
solarizedGreen   = "#859900"
-----------------------------------------------------------------------
-- Appeareance and standard definitions:
myTerminal           = "urxvtcd"
myFocusFollowsMouse  = True
myBorderWidth        = 4
myModMask            = mod4Mask
myWorkspaces         = withScreens 2 ["un","deux","trois","quatre","cinq","six","sept","huite","neuf"]
myNormalBorderColor  = "" ++ myNormalBGColor ++ ""
myFocusedBorderColor = "" ++ myFocusedFGColor ++ ""
myEventHook          = mempty
myStartupHook        = setWMName "LG3D"
--myLogHook            = (dynamicLogWithPP $ myDzenPP dzen)
--myFadeHook           = fadeInactiveLogHook 0.8
-----------------------------------------------------------------------
-- Prompt appeareance options:
myXPConfig = defaultXPConfig
  { font = "" ++ myFont ++ ""
  , bgColor = "" ++ myNormalBGColor ++ ""
  , fgColor = "" ++ myNormalFGColor ++ ""
  , fgHLight = "" ++ myNormalFGColor ++ ""
  , bgHLight = "" ++ myUrgentBGColor ++ ""
  , borderColor = "" ++ myFocusedBorderColor ++ ""
  , promptBorderWidth = 1
  , position = Bottom
  , height = 18
  , historySize = 100
  --, historyFilter = ""
  --, promptKeymap = ""
  --, completionKey = ""
  --, defaultText = ""
  --, autoComplete = "KeySym"
  --, showCompletionOnTab = ""
  }
-----------------------------------------------------------------------
-- Theme options:
myTheme = defaultTheme
  { activeColor         = S.base03
  , inactiveColor       = S.base02
  , urgentColor         = S.base02
  , activeBorderColor   = S.base0
  , inactiveBorderColor = S.base01
  , urgentBorderColor   = S.red
  , activeTextColor     = S.base0
  , inactiveTextColor   = S.base01
  , urgentTextColor     = S.orange
  }
-----------------------------------------------------------------------
-- Status bar options:
--xmobarCommand (S s) = unwords ["xmobar", "-x", show s, "-t", template s] where
--    template 1 = "%StdinReader%"
--   template _ = "%date%%StdinReader%"

--dzenCommand (S s) = unwords ["dzen2 -xs", show s, "-ta l -u"]

dzenCommand (S s) = unwords ["dzen2", "-xs", show s, dconf s] where
    dconf 1 = "-u -h '18' -ta 'l' -fg '" ++ myNormalFGColor ++ "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "' -u -e 'onstart=lower'" 
    dconf _ = "-u -h '18' -ta 'l' -fg '" ++ myNormalFGColor ++ "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "' -u -e 'onstart=lower'"

myStatusBar = "dzen2 -x '0' -y '0' -h '18' -w '3000' -ta 'l' -fg '" ++ S.base03 ++ "' -bg '" ++ S.base0 ++ "' -fn '" ++ myFont ++ "'"
--myStatusBarRight = "dzen2 -xs 2 -x '0' -y '0' -h '18' -w '1920' -ta 'l' -fg '" ++ myNormalFGColor ++ "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "'"
--myMPDBar = "/home/cgie/bin/mpdbar | dzen2 -x '1400' -y '1064' -h '21' -w '520' -ta 'l' -sa 'c' -l 3 -fg '" ++ myNormalFGColor ++ "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "' -e 'button4=exec:mpc volume +5;button5=exec:mpc volume -5;button1=exec:mpc next;button3=exec:mpc prev;button2=exec:mpc toggle;entertitle=uncollapse;leavetitle=collapse'"
--myClockBar = "/home/cgie/bin/clockbar | dzen2 -x '0' -y '1064' -h '18' -w '1920' -ta 'l' -fg '" ++ myNormalFGColor ++ "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "'"
--myMailBar = "/home/cgie/bin/mailbar | dzen2 -x '450' -y '1064' -h '18' -w '400' -ta 'l' -sa 'l' -l 3 -fg '" ++ myNormalFGColor ++ "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "' -e 'button1=exec:urxvtcd -e mutt;entertitle=uncollapse;leavetitle=collapse;button4=scrollup;button5=scrolldown;'"
--myStateBar = "/home/cgie/bin/statebar | dzen2 -x '870' -y '1064' -h '21' -w '830' -ta l -fg '" ++ myNormalFGColor ++ "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "' -e 'button1=exec:urxvtcd -e mutt;entertitle=uncollapse;leavetitle=collapse;button4=scrollup;button5=scrolldown;'"
-----------------------------------------------------------------------
-- Urgency alert options:
myUrgencyHook = withUrgencyHook dzenUrgencyHook
    { args = ["-x", "0", "-y", "1064", "-h", "21", "-w", "1920", "-ta", "r", "-expand", "l", "-fg", "" ++ myUrgentFGColor ++ "", "-bg", "" ++ myNormalBGColor ++ "", "-fn", "" ++ myFont ++ ""] }
-----------------------------------------------------------------------
-- Layouts:
myLayouts = avoidStruts $ layoutHints $ toggleLayouts (noBorders Full) $ onWorkspace "sept" septlayout $ globallayout
  where
  septlayout   = smartBorders $ withIM (1%5) (ClassName "Turpial") $ reflectHoriz $ withIM (1%4) (And (ClassName "Pidgin") (Role "buddy_list")) globallayout
--  septlayout   = smartBorders $ withIM (1%5) (ClassName "Choqok") $ reflectHoriz $ withIM (1%4) (And (ClassName "Pidgin") (Role "buddy_list")) Grid ||| normallayout
  globallayout = smartBorders $ normallayout
  normallayout = tiled ||| Mirror tiled ||| tabbed shrinkText myTheme ||| Circle
  tiled        = ResizableTall nmaster delta ratio []
  nmaster      = 1
  ratio        = toRational (2/(1+sqrt(5)::Double)) -- golden ratio!
  delta        = 3/100
-----------------------------------------------------------------------
-- Keybindings:
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ ((modMask              , xK_r         ), spawnHere "urxvtcd")
  , ((modMask,               xK_f         ), spawnHere "chromium")
  , ((modMask,               xK_F1        ), spawnHere "urxvtcd -e mutt")
  , ((modMask,               xK_F2        ), spawn "mathematica")
  , ((modMask,               xK_adiaeresis), namedScratchpadAction scratchpads "calc")
  , ((modMask,               xK_udiaeresis), namedScratchpadAction scratchpads "clock")
  , ((modMask,               xK_odiaeresis), namedScratchpadAction scratchpads "screen")
  , ((modMask,               xK_numbersign), namedScratchpadAction scratchpads "scribble")
  , ((modMask,               xK_F9        ), spawnHere "~/bin/wacom-left")
  , ((modMask,               xK_F10       ), spawnHere "~/bin/wacom-right")
  , ((modMask,               xK_F12       ), spawnHere "~/bin/wacom-init")
  , ((modMask,               xK_F3        ), spawnHere "pcmanfm")
  , ((modMask              , xK_Page_Up   ), spawn "transset-df -p --inc 0.01")
  , ((modMask              , xK_Page_Down ), spawn "transset-df -p --min 0.2 --dec 0.01")
  , ((modMask              , xK_BackSpace ), spawn "xmonad --recompile && xmonad --restart")
  , ((modMask,               xK_z         ), toggleWS)
  , ((modMask,               xK_space     ), refresh)
  , ((modMask,               xK_g         ), focusUrgent )
  , ((modMask              , xK_x         ), shellPromptHere myXPConfig)
  , ((modMask              , xK_q         ), kill)
  , ((modMask .|. shiftMask, xK_BackSpace ), io (exitWith ExitSuccess))
  , ((modMask,               xK_t         ), withFocused $ windows . W.sink)
  , ((modMask .|. shiftMask, xK_a         ), setLayout $ XMonad.layoutHook conf)
  , ((modMask,               xK_a         ), sendMessage NextLayout)
  , ((modMask .|. shiftMask, xK_Return    ), sendMessage ToggleLayout)
  , ((modMask,               xK_h         ), sendMessage Shrink)
  , ((modMask,               xK_l         ), sendMessage Expand)
  , ((modMask,               xK_Down      ), sendMessage Shrink)
  , ((modMask,               xK_Up        ), sendMessage Expand)
  , ((modMask              , xK_comma     ), sendMessage (IncMasterN 1))
  , ((modMask              , xK_period    ), sendMessage (IncMasterN (-1)))
  , ((modMask              , xK_b         ), sendMessage ToggleStruts)
  , ((modMask,               xK_c         ), sendMessage MirrorShrink)
  , ((modMask,               xK_v         ), sendMessage MirrorExpand)
  , ((modMask,               xK_Right     ), windows W.focusDown)
  , ((modMask,               xK_Left      ), windows W.focusUp)
  , ((modMask,               xK_m         ), windows W.focusMaster)
  , ((modMask,               xK_j         ), windows W.focusDown)
  , ((modMask,               xK_k         ), windows W.focusUp)
  , ((modMask .|. shiftMask, xK_j         ), windows W.swapDown)
  , ((modMask .|. shiftMask, xK_k         ), windows W.swapUp)
  , ((modMask,               xK_Return    ), windows W.swapMaster)
  , ((modMask .|. shiftMask, xK_Right     ), windows W.swapDown)
  , ((modMask .|. shiftMask, xK_Left      ), windows W.swapUp)
  ]
  ++
  [ ((m .|. modMask, k), windows $ onCurrentScreen f i)
  | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]
  ++
  [ ((m .|. modMask, k), windows $ onCurrentScreen f i)
  | (i, k) <- zip (workspaces' conf) [xK_KP_End, xK_KP_Down, xK_KP_Next, xK_KP_Left, xK_KP_Begin, xK_KP_Right, xK_KP_Home, xK_KP_Up, xK_KP_Prior]
  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]
  ++
  -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_KP_Insert, xK_KP_Delete] [0,1]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
-----------------------------------------------------------------------
-- Mouse bindings:
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
  , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
  , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
--  , ((modMask, button4), spawn "transset-df -p --inc 0.2")
--  , ((modMask, button5), spawn "transset-df -p --min 0.2 --dec 0.2")
  ]
-----------------------------------------------------------------------
-- Window management:


myManageHook = namedScratchpadManageHook scratchpads <+> composeAll
  [ isFullscreen                       --> doFullFloat
  , className =? "MPlayer"             --> doFloat
  , className =? "Gimp"                --> doFloat
  , className =? "feh"                 --> doFloat
  , className =? "Xmessage"            --> doCenterFloat
  , className =? "XMathematica"        --> doF (W.shift "quatre")
  , className =? "Liferea"             --> doF (W.shift "sept")
  , (stringProperty "WM_WINDOW_ROLE" =? "scribble"
    --> (ask >>= \w -> liftX (setOpacity w 0.7) >> idHook))
  , resource  =? "desktop_window"      --> doIgnore
  , resource  =? "kdesktop"            --> doIgnore
  ]
-----------------------------------------------------------------------
-- dynamicLog format for dzen:
myDzenPP h s = marshallPP s dzenPP 
    { ppCurrent = wrap ("^fg(" ++ myIconFGColor ++ ")^bg(" ++ myFocusedBGColor ++ ")^p()^i(" ++ myIconDir ++ "/has_win.xbm)^fg(" ++ myDzenFGColor ++ ")") "^fg()^bg()^p()" . pad
    , ppVisible = wrap ("^fg(" ++ myNormalFGColor ++ ")^bg(" ++ myNormalBGColor ++ ")^p()^i(" ++ myIconDir ++ "/has_win.xbm)^fg(" ++ myNormalFGColor ++ ")") "^fg()^bg()^p()" . pad
    , ppHidden = wrap ("^fg(" ++ myNormalFGColor ++ ")^bg(" ++ myNormalBGColor ++ ")^p()^i(" ++ myIconDir ++ "/has_win.xbm)^fg(" ++ myNormalFGColor ++ ")") "^fg()^bg()^p()" . pad
    , ppHiddenNoWindows = wrap ("^fg(" ++ myNormalFGColor ++ ")^bg(" ++ myNormalBGColor ++ ")^p()^i(" ++ myIconDir ++ "/has_win_nv.xbm)^fg(" ++ myFocusedBGColor ++ ")") "^fg()^bg()^p()" . pad
    , ppUrgent = wrap (("^fg(" ++ myUrgentFGColor ++ ")^bg(" ++ myUrgentBGColor ++ ")^p()^i(" ++ myIconDir ++ "/has_win.xbm)^fg(" ++ myUrgentFGColor ++ ")")) "^fg()^bg()^p()" . pad
    , ppSep = " "
    , ppWsSep = " "
    , ppTitle = dzenColor ("" ++ myNormalFGColor ++ "") "" . wrap "< " " >"
    , ppLayout = dzenColor ("" ++ myNormalFGColor ++ "") "" .
        (\x -> case x of
        "Hinted Full" -> "^fg(" ++ myIconFGColor ++ ")^i(" ++ myIconDir ++ "/stop.xbm)"
        "Hinted ResizableTall" -> "^fg(" ++ myIconFGColor ++ ")^i(" ++ myIconDir ++ "/tall.xbm)"
        "Hinted Mirror ResizableTall" -> "^fg(" ++ myIconFGColor ++ ")^i(" ++ myIconDir ++ "/mtall.xbm)"
        "Hinted Tabbed Simplest" -> "^fg(" ++ myIconFGColor ++ ")^i(" ++ myIconDir ++ "/mem.xbm)"
        "Hinted Circle" -> "^fg(" ++ myIconFGColor ++ ")^i(" ++ myIconDir ++ "/empty.xbm)"
        "Hinted IM ReflectX IM ResizableTall" -> "^fg(" ++ myIconFGColor ++ ")^i(" ++ myIconDir ++ "/info_02.xbm)"
        _ -> x
        )
    , ppSort = fmap (. namedScratchpadFilterOutWorkspace) $ (mkWsSort getWsCompare')
--    , ppSort = mkWsSort getWsCompare'
    , ppOutput = hPutStrLn h
    }

-----------------------------------------------------------------------
-- This is needed for IndependentScreens which garbles the order of the
-- workspaces.

getWsIndex' :: X (WorkspaceId -> Maybe Int)
getWsIndex' = do
    spaces <- asks (workspaces' . config)
    return $ flip elemIndex spaces

getWsCompare' :: X WorkspaceCompare
getWsCompare' = do
    wsIndex <- getWsIndex'
    return $ mconcat [compare `on` wsIndex, compare]

