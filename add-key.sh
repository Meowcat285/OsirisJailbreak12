#!/bin/sh
security create-keychain -p travis ios-build.keychain
security import ./script/certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./script/certs/distribution.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./script/certs/$PROVISIONING_PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
