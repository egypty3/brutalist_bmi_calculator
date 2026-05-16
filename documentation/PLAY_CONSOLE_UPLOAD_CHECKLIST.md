# Google Play Console upload checklist

## Ready-to-upload artifacts
- App bundle: `build/app/outputs/bundle/release/app-release.aab`
- Version: `1.1.0+6`
- Release notes: `documentation/PLAY_CONSOLE_RELEASE_NOTES_1.1.0+6.md`
- Store listing copy: `documentation/PLAY_CONSOLE_STORE_LISTING_1.1.0+6.md`

## Steps in Play Console
1. Open your app in Google Play Console.
2. Go to **Testing** or **Production** depending on where you want to release.
3. Click **Create new release**.
4. Upload `app-release.aab`.
5. Enter the release name: `Brutalist BMI Calculator 1.1.0 (6)`.
6. Paste the release notes into each language field using the tag blocks from `PLAY_CONSOLE_RELEASE_NOTES_1.1.0+6.md`.
7. Review warnings and complete any required store listing or policy items.
8. Save the release, then review and roll out when ready.

## Notes
- The app bundle was built successfully in release mode.
- The project version in `pubspec.yaml` is already set to `1.1.0+6`.
- If Play Console asks for a newer version code later, increase the build number after each release.

