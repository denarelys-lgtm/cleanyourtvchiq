# CHiQ AI PONT SA (`ahua`) — experimental profile

Status: **candidate / not field-tested**. Based on the owner's Clean Your TV report captured
2026-10-26, not on a completed reboot or HOME-button test.

## Match

- Brand: CHiQ; manufacturer: Changhong
- Model: `AI PONT SA`
- Device: `ahua`
- Android: 11 / SDK 30
- Build: `CHiQ/GTV_98CH/ahua:11/RTK3.240516.048/12350861:user/release-keys`
- HOME: `com.google.android.apps.tv.launcherx/.home.HomeActivity`

The candidate match includes the reported fingerprint prefix. A different firmware does not
silently inherit this untested list; it falls back to the brand-level profile resolution.

## Cleanup scope

Only `com.google.android.feedback` is default-off. The screensaver, calendar sync, YouTube Music,
and Play Games rows are optional (`ASK`) and remain enabled unless the owner explicitly selects
them. No package absent from the supplied report is added to this candidate list.

The profile's `neverDisable` set protects Google TV Launcher X, Setup Wraith, Realtek's key
interception/global-key components, Realtek TV/tuner/HDMI paths, status bar/media browser, power/setup/factory/keyboard
components, Android TV settings/provider, Bluetooth, Google TV remote/casting, OTA updater,
SystemUI, Play services and package/permission controllers.

## HOME behaviour

The normal launcher takeover is not enabled by this profile. In particular, neither
`com.google.android.apps.tv.launcherx` nor `com.google.android.tungsten.setupwraith` is disabled.
The report also shows `com.realtek.keyintercept/.fallbackhome.FallbackHome`; it is protected.

The experimental Home Button Helper is opt-in and is available only in a test build. It keeps the
stock HOME target, configures `stock_home_redirect` to Google's Launcher X and sets `key_filter`
to `false`. It adds only Clean Your TV's `HomeKeyService` to the accessibility list. The planner
refuses unsafe list states, uses a TV-side watchdog, checks the foreground after HOME, and rolls
back if the new launcher does not take over. It does not grant permissions, change app-ops, remap
remote buttons, or disable vendor apps.

This is not proof that the CHiQ firmware will permit the helper to bind or that Realtek's fallback
will always be redirected. Validate on the physical TV and keep the original launcher enabled.

## Build

Run from the project root:

```sh
./scripts/build-chiq-ai-pont-sa-experimental.sh
```

The script fetches the pinned upstream launcher submodule (`b06ab21`) if it is absent, runs the
spec/planner/app unit tests, and assembles `app/build/outputs/apk/full/debug/app-full-debug.apk`.
The APK is marked `0.4.8-alpha1` / versionCode `31`; the ordinary release configuration remains
`0.4.8` / versionCode `30` and does not bundle candidate or Home Helper markers.

## Required physical-TV checks before treating this as supported

1. Install the test APK and connect ADB; confirm the report still matches the exact profile.
2. Review the cleanup plan; confirm only the intended packages are selected.
3. Apply cleanup alone first; verify Wi-Fi, Live TV/channel scan, HDMI inputs, Bluetooth remote,
   voice, casting, OTA/update screen and factory/settings menus.
4. Restore any optional app that causes a regression.
5. Only then test Home Button Helper with the stock launcher still enabled. Confirm HOME opens the
   new launcher repeatedly, then test Back, Power, Input, volume, app shortcut keys and reboot.
6. If the helper fails, use its Switch off/rollback path; do not disable Launcher X or Setup Wraith
   manually. Send a new TV report and the helper status for further tuning.

No reboot-survival claim is made until these checks have been completed on this exact set.
