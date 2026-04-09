#!/bin/bash

: <<'DOC'
======================================================================
GUIDE: CONFIGURE RCLONE WITH CUSTOM GOOGLE DRIVE API CREDENTIALS
======================================================================

# Guide: Configure Rclone with Custom Google Drive API Credentials

The process is divided into two parts: generating the keys on Google and configuring Rclone in the terminal.

## Part 1: Obtaining the Client ID and Client Secret on Google

1. **Access the Google Cloud Console:**
   * Go to [console.cloud.google.com](https://console.cloud.google.com/) and log in with the Google account where your Drive is located.
2. **Create a New Project:**
   * In the top left corner (next to the Google Cloud logo), click the project dropdown menu and then **New Project**.
   * Give it a name (like `RcloneDrive`) and click **Create**. Wait a few seconds for the project to be created and make sure it is selected.
3. **Enable the Google Drive API:**
   * In the left sidebar (hamburger menu), go to **APIs & Services** > **Library**.
   * In the search bar, type `Google Drive API` and click the corresponding option.
   * Click the blue **Enable** button.
4. **Configure the OAuth Consent Screen:**
   * In the left menu, go to **APIs & Services** > **OAuth consent screen**.
   * Choose the User Type **External** (if you use a standard `@gmail.com` account) or **Internal** (if using Workspace). Click **Create**.
   * Fill in only the required fields:
     * **App name:** `RcloneApp` (or whatever you prefer).
     * **User support email:** Choose your email.
     * **Developer contact information:** Enter your email again.
   * Click **Save and Continue**. On the **Scopes** screen, just click **Save and Continue** again.
   * On the **Test users** screen (very important!), click **+ Add Users** and add the email address of your own Google Drive. Click **Save and Continue**, then go back to the dashboard.
5. **Create Credentials:**
   * In the left menu, click **Credentials**.
   * At the top of the page, click **+ Create Credentials** and select **OAuth client ID**.
   * Under **Application type**, select **Desktop app**.
   * Give it a name and click **Create**.
6. **Save the Keys:**
   * A window will appear containing your **Client ID** and **Client Secret**. Leave this window open or copy these two codes to a notepad.

---

## Part 2: Configuring Rclone in the Terminal

With the keys in hand, open your terminal.

1. **Start the Rclone wizard:**
   ```bash
   rclone config
   ```
2. **Create a new remote:**
   * Type `n` (for *New remote*) and press Enter.
   * Type the name for this connection (e.g., `gdrive`). **Attention:** This is the name that must be used in the `REMOTE_NAME` variable of this script.
3. **Choose the service (Google Drive):**
   * A long list of services will appear. Look for "Google Drive" and type the corresponding number, or simply type `drive` and press Enter.
4. **Enter Google Keys:**
   * At `client_id>`, paste the **Client ID** you copied from Google Cloud and press Enter.
   * At `client_secret>`, paste the **Client Secret** and press Enter.
5. **Define Permissions (Scope):**
   * At `scope>`, type `1` to give full access to the drive and press Enter.
6. **Skip optional fields:**
   * At `service_account_file>`, just leave it blank and press Enter.
   * At `Edit advanced config?`, type `n` (no).
7. **Browser Authentication:**
   * At `Use auto config?`, type `y` (yes).
   * Your browser will open automatically. Log in with your Google account (the same one you added as a "Test user").
   * Since your app hasn't been submitted for Google's approval, a warning screen will say "Google hasn't verified this app". Click **Advanced** and then **Go to RcloneApp (unsafe)**.
   * Grant permission by clicking **Continue/Allow**. The browser will show a "Success!" message.
8. **Finish in the Terminal:**
   * Go back to the terminal. At `Configure this as a Shared Drive (Team Drive)?`, type `n` (no), unless it is a corporate team drive.
   * Rclone will show a summary of everything. Type `y` to confirm and save.
   * Type `q` to quit the menu.
======================================================================
DOC

# Configuration variables
REMOTE_NAME="GoogleDrive:" # Change this to your configured remote name in rclone
MOUNT_POINT="$HOME/GoogleDrive"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/google_drive.desktop"

# Gets the absolute path of wherever this script is currently located
SCRIPT_PATH="$(realpath "$0")"

# 1. Function to ensure the .desktop file exists
setup_desktop_entry() {
    if [ ! -f "$DESKTOP_FILE" ]; then
        echo "Creating .desktop entry for the first time..."
        mkdir -p "$DESKTOP_DIR"

        cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Google Drive
Comment=Mount and unmount Google Drive
Exec=$SCRIPT_PATH
Icon=folder-remote
Terminal=false
Categories=Network;Utility;
EOF

        chmod +x "$DESKTOP_FILE"

        if command -v update-desktop-database &> /dev/null; then
            update-desktop-database "$DESKTOP_DIR"
        fi
    fi
}

# 2. Function to mount the drive
mount_drive() {
    mkdir -p "$MOUNT_POINT"
    
    # Mount command (rclone running as a daemon in the background)
    rclone mount "$REMOTE_NAME" "$MOUNT_POINT" --daemon
    
    # Send a system notification (GNOME/KDE compatible)
    if command -v notify-send &> /dev/null; then
        notify-send "Google Drive" "Mounted successfully at $MOUNT_POINT" -i folder-remote
    fi
}

# 3. Function to unmount the drive
unmount_drive() {
    # Unmount command for FUSE filesystems
    fusermount -u "$MOUNT_POINT"
    
    # Send a system notification
    if command -v notify-send &> /dev/null; then
        notify-send "Google Drive" "Unmounted successfully" -i folder-remote
    fi
}

# --- Main Execution ---

# Ensure the shortcut exists before doing anything
setup_desktop_entry

# Check if the directory is currently an active mountpoint
if mountpoint -q "$MOUNT_POINT"; then
    unmount_drive
else
    mount_drive
fi