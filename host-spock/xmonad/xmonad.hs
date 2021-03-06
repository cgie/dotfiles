
--------------------------------------------------------------------------------
-- ~/.xmonad/xmonad.hs

import XMonad
import XMonad.Hooks.EwmhDesktops
import System.Exit (exitSuccess)
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive -- (setOpacity)
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Input
import Data.Monoid
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Layout.IndependentScreens
import Data.Ratio ((%))
import XMonad.Hooks.SetWMName
import XMonad.Layout.ResizableTile
import XMonad.Layout.OneBig
import XMonad.Layout.Roledex
import XMonad.Layout.Tabbed
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Hooks.ManageHelpers
import Data.List (elemIndex)
import Data.Function (on)
import XMonad.Util.WorkspaceCompare
import qualified Solarized.Light as S
--------------------------------------------------------------------------------
-- My Scratchpads

scratchpads = [ NS "screen"   spawnScreen  findScreen   manageScreen
              , NS "calc"     spawnCalc    findCalc     manageCalc
              , NS "clock"    spawnClock   findClock    manageClock
              , NS "scribble" spawnXournal findXournal  manageXournal
              , NS "cheat"    spawnCheat   findCheat    manageCheat
              ]
  where
    spawnScreen  = myTerminal ++ " -name scratchpad -e screen -c ~/.screen/configs/scratchpad -S scratchpad -D -R scratchpad screen"
    findScreen   = resource =? "scratchpad"
    manageScreen = customFloating $ W.RationalRect l t w h
      where
        h = 0.6
        w = 0.9
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

    spawnClock = myTerminal ++ " -name clock -e /usr/local/bin/tty-clock -scC4 -f '%c'"
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

    spawnCheat  = "feh --title cheat -Fd /home/cgie/.cheatsheets/"
    findCheat   = title =? "cheat"
      where title = stringProperty "WM_NAME"
    manageCheat = defaultFloating

--------------------------------------------------------------------------------
-- Color and font definitions:
-- Appeareance and standard definitions:
myFont = "Monofur for Powerline:pixelsize=20:antialias=true:hinting=true"
myIconDir = "/home/cgie/usr/share/dzen_bitmaps"
myTerminal           = "urxvt"
myFocusFollowsMouse  = True
myBorderWidth        = 0
myModMask            = mod4Mask
myWorkspaces         = withScreens 2 ["un","deux","trois","quatre","cinq","six"
                                     ,"sept","huite","neuf"
                                     ]
myStartupHook        = setWMName "LG3D"
-----------------------------------------------------------------------
-- Prompt appeareance options:

myXPConfig :: XPConfig
myXPConfig = defaultXPConfig
  { font = "xft:" ++ myFont
  , bgColor = S.base03
  , fgColor = S.base3
  , promptKeymap = M.insert (shiftMask, xK_Insert) pasteString defaultXPKeymap
  }

myMicroBlogPrompt:: String -> X ()
myMicroBlogPrompt s = spawn ("bash /home/cgie/bin/noblog " ++ s)

myPwsafePrompt :: String -> X ()
myPwsafePrompt s = spawn ("urxvt -pe -default,-matcher,-tabbed -tr -bg black -sh 100 -g 400x2 -title pwsafe -e pwsafe -p " ++ s)
-----------------------------------------------------------------------
-- Status bar options:
-- Too complex, but I'll change the left one some day anyway...

dzenCommand (S s) = unwords ["dzen2", "-p", "-xs", show s, dconf s]
  where dconf 1 = "-u -h '20' -ta 'l' -fg '" ++ S.base0 ++ "' -bg '"
                  ++ S.base03 ++ "' -fn '" ++ myFont
                  ++ "' -u -e 'onstart=lower'"
        dconf _ = "-u -h '20' -ta 'l' -fg '" ++ S.base0 ++ "' -bg '"
                  ++ S.base03 ++ "' -fn '" ++ myFont
                  ++ "' -u -e 'onstart=lower'"
-----------------------------------------------------------------------
-- Layouts:

myLayouts = avoidStruts $ smartBorders $  tiled ||| Mirror tiled ||| OneBig (3/4) (3/4) ||| Roledex ||| simpleTabbed ||| Full
  where
  tiled        = ResizableTall nmaster delta ratio []
  nmaster      = 1
  ratio        = toRational (2/(1+sqrt 5 ::Double)) -- golden ratio!
  delta        = 3/100
-----------------------------------------------------------------------
-- Keybindings:

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [ ((modMask              , xK_r         ), spawn "urxvt")
  , ((modMask,               xK_f         ), spawn "dwb")
  , ((modMask,               xK_F1        ), spawn "urxvt -e mutt")
  , ((modMask,               xK_F2        ), namedScratchpadAction scratchpads "cheat")
  , ((modMask,               xK_adiaeresis), namedScratchpadAction scratchpads "calc")
  , ((modMask,               xK_udiaeresis), namedScratchpadAction scratchpads "clock")
  , ((modMask,               xK_odiaeresis), namedScratchpadAction scratchpads "screen")
  , ((modMask,               xK_numbersign), namedScratchpadAction scratchpads "scribble")
  , ((modMask,               xK_F9        ), spawn "~/bin/wacom-left")
  , ((modMask,               xK_F10       ), spawn "~/bin/wacom-right")
  , ((modMask,               xK_F12       ), spawn "~/bin/wacom-init")
  , ((modMask,               xK_F3        ), spawn "pcmanfm")
  , ((modMask,               xK_F4        ), inputPrompt myXPConfig "New Message" ?+ myMicroBlogPrompt)
  , ((modMask              , xK_Page_Up   ), spawn "transset-df -p --inc 0.01")
  , ((modMask              , xK_Page_Down ), spawn "transset-df -p --min 0.2 --dec 0.01")
  , ((modMask              , xK_BackSpace ), spawn customRestart)
  , ((modMask,               xK_p         ), inputPrompt myXPConfig "pwsafe" ?+ myPwsafePrompt )
  , ((modMask,               xK_space     ), refresh)
  , ((modMask              , xK_x         ), shellPrompt myXPConfig)
  , ((modMask              , xK_q         ), kill)
  , ((modMask .|. shiftMask, xK_BackSpace ), io exitSuccess)
  , ((modMask,               xK_s         ), spawn toggleRestart)
  , ((modMask,               xK_t         ), withFocused $ windows . W.sink)
  , ((modMask .|. shiftMask, xK_a         ), setLayout $ XMonad.layoutHook conf)
  , ((modMask,               xK_a         ), sendMessage NextLayout)
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
  | (i, k) <- zip (workspaces' conf) [xK_KP_End, xK_KP_Down, xK_KP_Next
                                     , xK_KP_Left, xK_KP_Begin, xK_KP_Right
                                     , xK_KP_Home, xK_KP_Up, xK_KP_Prior
                                     ]
  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]
  ++
  -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_m, xK_n] [0,1]
      -- | (key, sc) <- zip [xK_KP_Insert, xK_KP_Delete] [0,1]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
-----------------------------------------------------------------------
-- Mouse bindings:
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
  [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
  , ((modMask, button2), \w -> focus w >> windows W.swapMaster)
  , ((modMask, button3), \w -> focus w >> mouseResizeWindow w)
  ]
-----------------------------------------------------------------------
-- Window management:
--
myManageHook = namedScratchpadManageHook scratchpads <+> composeAll
  [ isFullscreen                       --> doFullFloat
  , className =? "MPlayer"             --> doFloat
  , className =? "feh"                 --> doFloat
  , className =? "Xmessage"            --> doCenterFloat
  , className =? "XMathematica"        --> doF (W.shift "quatre")
  , className =? "Liferea"             --> doF (W.shift "sept")
  , className =? "URxvt"
    --> (ask >>= \w -> liftX (setOpacity w 0.90) >> idHook)
  , stringProperty "WM_WINDOW_ROLE" =? "scribble"
    --> (ask >>= \w -> liftX (setOpacity w 0.8) >> idHook)
  , resource  =? "desktop_window"      --> doIgnore
  , resource  =? "kdesktop"            --> doIgnore
  , title     =? "pwsafe"              --> doFloat
  ]
-----------------------------------------------------------------------
-- dynamicLog format for dzen:
--
myDzenPP h s = namedScratchpadFilterOutWorkspacePP $ marshallPP s dzenPP
  { ppCurrent         = dzenColor S.base03 S.base00. pad
  , ppHidden          = dzenColor S.base2 "" . pad
  , ppHiddenNoWindows = dzenColor S.base1 "" . pad
  , ppLayout          = dzenColor S.base2 "" . pad
  , ppUrgent          = dzenColor S.red "" . pad . dzenStrip
  , ppTitle           = shorten 100
  , ppWsSep           = ""
  , ppSep             = "  "
  , ppOutput          = hPutStrLn h
  , ppSort            = fmap (. namedScratchpadFilterOutWorkspace) $ (mkWsSort getWsCompare')
  }
-------------------------------------------------------------------------
-- This is needed for IndependentScreens which garbles the order of the
-- workspaces.
--
getWsIndex' :: X (WorkspaceId -> Maybe Int)
getWsIndex' = do
    spaces <- asks (workspaces' . config)
    return $ flip elemIndex spaces

getWsCompare' :: X WorkspaceCompare
getWsCompare' = do
    wsIndex <- getWsIndex'
    return $ mconcat [compare `on` wsIndex, compare]

-------------------------------------------------------------------------
-- Custom stuff

customRestart = "m4 -DSOLARIZEDTHEME=$(cat /home/cgie/.solarizedstatus) /home/cgie/.xmonad/xmonad.m4 /home/cgie/.xmonad/xmonad.hs.in > /home/cgie/.xmonad/xmonad.hs && for pid in `pgrep dzen2`; do kill -9 $pid; done && xmonad --recompile && xmonad --restart"
toggleRestart = "/home/cgie/bin/solarizedtoggle && for pid in `pgrep dzen2`; do kill -9 $pid; done && xmonad --recompile && xmonad --restart"


-------------------------------------------------------------------------
-- main
--
main = do
  nScreens <- countScreens
  handles <- mapM (spawnPipe . dzenCommand) [1 .. nScreens]
  xmonad $ defaultConfig
    { terminal           = myTerminal
    , focusFollowsMouse  = myFocusFollowsMouse
    , borderWidth        = myBorderWidth
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    , normalBorderColor  = S.base0
    , focusedBorderColor = S.yellow
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
    , layoutHook         = myLayouts
    , handleEventHook    = handleEventHook defaultConfig <+> fullscreenEventHook
    , manageHook         = myManageHook  <+> manageDocks
    , logHook            = fadeInactiveLogHook 1 <+> (mapM_ dynamicLogWithPP $ zipWith myDzenPP handles [0..nScreens-1])
--    , logHook            = mapM_ dynamicLogWithPP $ zipWith myDzenPP handles [0..nScreens-1]
    , startupHook        = myStartupHook
    }

