# CleanYourTV — CHiQ AI PONT SA (`ahua`) experimental modification

Prepared from the supplied source archive and the TV report dated 2026-10-26.

## What changed

- Added a test-build-only candidate profile `chiq-ai-pont-sa-ahua`, pinned to model `AI PONT SA`, device `ahua`, Android SDK 30 and the reported firmware fingerprint.
- The candidate defaults off only `com.google.android.feedback`. Screensaver, calendar sync, YouTube Music and Play Games are optional ASK rows; no ad-serving or tuner package is guessed.
- Added a broad `neverDisable` protection list for the exact reported Google TV, Setup Wraith, Realtek key/tuner/HDMI/power/setup/factory, Android TV, Bluetooth, remote, casting, OTA and system packages.
- Kept Setup Wraith and the Realtek fallback HOME claimant enabled. The profile does not enable the normal launcher takeover.
- Added regression tests for exact profile matching, protected packages and the watchdog-backed Home Button Helper plan with the report's three HOME claimants.
- Clarified in SetupMachine why `WIZARD_STAYS_ON` and `VENDOR_HOME` do not automatically prevent the helper: the helper keeps the stock HOME apps enabled.
- Added a Termux/GitHub Actions build script and a manual GitHub Actions workflow.
- Experimental APK identity is `0.4.8-alpha1`, versionCode `31`; normal builds remain `0.4.8`, versionCode `30`.

## Important limitations

- This is a candidate profile, not a tested upstream profile. It must be explicitly accepted in the test app before use.
- The only default cleanup action is Google feedback telemetry. The supplied report does not establish a safe package for removing Google TV home-screen advertising; LauncherX stays enabled for the helper.
- Home Button Helper remains experimental. It has a watchdog and rollback, but this exact firmware has not yet been physically tested for HOME redirection or reboot survival.
- No APK is included. Gradle tests/build could not be executed in this environment because the wrapper distribution could not be downloaded and the source archive omits the upstream git submodule. The provided script fetches the pinned upstream revision before building.
