#!/bin/bash


dir=${0%/*}
if [ -d "$dir" ]; then
	cd "$dir"
fi

APP_NAME="Cricket Score Applet"
VERSION="1.0.0"
DMG_BACKGROUND_IMG="background.png"

APP_EXE="${APP_NAME}.app/Contents/MacOS/${APP_NAME}"

VOL_NAME="${APP_NAME} ${VERSION}"
DMG_TMP="${VOL_NAME}-temp.dmg"
DMG_FINAL="${VOL_NAME}.dmg"
STAGING_DIR="./Install"

rm -rf "${STAGING_DIR}" "${DMG_TMP}" "${DMG_FINAL}"

mkdir -p "${STAGING_DIR}"
cp -rpf "${APP_NAME}.app" "${STAGING_DIR}"

pushd "${STAGING_DIR}"
echo "Stripping ${APP_EXE}...."
strip -u -r "${APP_EXE}"

if hash upx 2>/dev/null; then
	echo "Compressing (UPX) ${APP_EXE}...."
	upx -9 "${APP_EXE}"
fi

popd


SIZE=`du -sh "${STAGING_DIR}" | sed 's/\([0-9]*\)M\(.*\)/\1/'`
SIZE=`echo "${SIZE} + 1.0" | bc | awk '{print int($1+0.5)}'`

if [ $? -ne 0 ]; then
echo "Error: Cannot compute size of staging dir"
exit
fi

# create the temp DMG file
hdiutil create -srcfolder "${STAGING_DIR}" -volname "${VOL_NAME}" -fs HFS+ \
-fsargs "-c c=64,a=16,e=16" -format UDRW -size ${SIZE}M "${DMG_TMP}"

echo "Created DMG: ${DMG_TMP}"

# mount it and save the device
DEVICE=$(hdiutil attach -readwrite -noverify "${DMG_TMP}" | \
egrep '^/dev/' | sed 1q | awk '{print $1}')

sleep 2

echo "Add link to /Applications"
pushd /Volumes/"${VOL_NAME}"
ln -s /Applications
popd

# add a background image
mkdir /Volumes/"${VOL_NAME}"/.background
cp "${DMG_BACKGROUND_IMG}" /Volumes/"${VOL_NAME}"/.background/

# tell the Finder to resize the window, set the background,
#  change the icon size, place the icons in the right position, etc.
echo '
tell application "Finder"
tell disk "'${VOL_NAME}'"
open
set current view of container window to icon view
set toolbar visible of container window to false
set statusbar visible of container window to false
set the bounds of container window to {400, 100, 920, 440}
set viewOptions to the icon view options of container window
set arrangement of viewOptions to not arranged
set icon size of viewOptions to 72
set background picture of viewOptions to file ".background:'${DMG_BACKGROUND_IMG}'"
set position of item "'${APP_NAME}'.app" of container window to {160, 205}
set position of item "Applications" of container window to {360, 205}
close
open
update without registering applications
delay 2
end tell
end tell
' | osascript

sync


# unmount it
hdiutil detach "${DEVICE}"

# now make the final image a compressed disk image
echo "Creating compressed image"
hdiutil convert "${DMG_TMP}" -format UDZO -imagekey zlib-level=9 -o "${DMG_FINAL}"

# clean up
rm -rf "${DMG_TMP}"
rm -rf "${STAGING_DIR}"

echo 'Done.'

exit

