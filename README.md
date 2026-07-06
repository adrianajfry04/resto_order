# Resto Order — Setup Guide

Full step-by-step to get this running from zero. Follow in order.

## 1. Prerequisites
- Flutter SDK installed (latest stable) — `flutter --version` should work in terminal
- VS Code with Flutter & Dart extensions
- Android Studio with an emulator created (or a real Android device with USB debugging on)
- A free Supabase account: https://supabase.com

## 2. Create the Supabase project
1. Go to https://supabase.com/dashboard → **New project**.
2. Name: `resto-order` (or anything). Set a database password (save it somewhere).
3. Region: **Singapore** (closest to Malaysia).
4. Wait ~2 minutes for provisioning.

## 3. Create the database schema
1. In the Supabase dashboard, go to **SQL Editor** → **New query**.
2. Open `schema.sql` (included in this project folder), copy all of it, paste into the editor.
3. Click **Run**. You should see "Success. No rows returned" and the 3 tables will appear under **Table Editor**, pre-loaded with 6 sample menu items.

## 4. Get your API credentials
1. In Supabase dashboard: **Project Settings** (gear icon) → **API**.
2. Copy the **Project URL** (looks like `https://xxxxxxxxxxxx.supabase.co`).
3. Copy the **anon public** key (long string under Project API keys).

## 5. Generate the platform folders (android/ios/etc.)
This project ships with only `lib/`, `pubspec.yaml`, and config files — the platform
folders (android, ios, etc.) need to be generated once by the Flutter SDK on your machine
(they're large and machine-specific, so they aren't included in the zip).

In the project folder, run:

```bash
flutter create .
```

This fills in `android/`, `ios/`, `web/`, etc. around your existing `lib/` and `pubspec.yaml`
without touching them.

## 6. Plug credentials into the app
Open `lib/main.dart` and replace these two lines near the top:

```dart
const String kSupabaseUrl = 'https://YOUR_PROJECT_REF.supabase.co';
const String kSupabaseAnonKey = 'YOUR_ANON_PUBLIC_KEY';
```

with your actual Project URL and anon key from Step 4.

## 7. Install dependencies
In the project folder, run:

```bash
flutter pub get
```

## 8. Run the app
1. Start your Android emulator (Android Studio → Device Manager → Play button), or plug in a real device.
2. In VS Code, select the device in the bottom-right corner (or run `flutter devices` to check it's detected).
3. Run:

```bash
flutter run
```

## 9. Test the flows (for your report screenshots)
1. **Menu tab** — you should see the 6 seeded items. Tap **+** to add a new item, tap the pencil icon to edit one, toggle the switch to mark unavailable, tap the trash icon to delete one.
2. **Orders tab** — tap **+** to create a new order: enter a table number, tap **+/-** next to 2–3 menu items to set quantities, tap **Place Order**.
3. Tap the new order in the list to open **Order Detail**. While it's Pending you can adjust quantities or **Cancel Order**.
4. Tap **Advance to Preparing**, then **Advance to Served**, then **Advance to Paid** to walk through the full lifecycle.
5. Go back to Menu tab and delete a menu item you're no longer using — note the order you already placed still shows the correct name/price (that's the snapshot feature).

## 10. Take your 5 screenshots
With the emulator open, use the camera icon in the emulator's side toolbar to capture:
1. Menu list
2. Add/Edit menu item form
3. Orders list (try switching the status filter chips)
4. New order screen (with a couple of items and quantities selected, showing the total)
5. Order detail screen (showing items, total, and the advance-status button)

## 11. Package for submission
From the project's parent folder:

```bash
# Remove build artifacts first (optional, keeps zip small)
flutter clean

# Then zip everything except node_modules/build (Windows: right-click > Send to > Compressed folder;
# Mac: right-click > Compress; or use a terminal zip command excluding build/)
```

Rename the zip to `FinalTest_<MatricNo>_<Name>.zip` per the brief, and submit it together with your report PDF on eLearning.

## Troubleshooting
- **"Invalid API key" / auth errors**: double check you copied the **anon public** key, not the service_role key, and there's no trailing space.
- **Empty menu list on first run**: check the SQL ran successfully in Table Editor → menu_items should have 6 rows.
- **Emulator can't reach Supabase**: make sure the emulator has internet access (it does by default) and your firewall/antivirus isn't blocking it.
- **RLS / permission denied errors**: re-run the policy-creation part of `schema.sql` — RLS is on but the "public full access" policies must exist for the anon key to read/write.
