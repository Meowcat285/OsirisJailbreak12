#!/bin/sh

echo "Building and running unit tests"
rake test

if [[ $? != 0 ]]; then
  echo "Tests failed, exiting."
  exit 1
fi

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
if [[ "$TRAVIS_BRANCH" != "release/beta" ]]; then
  echo "Testing on a branch other than release/beta. No deployment will be done."
  exit 0
fi

RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`
TF_RELEASE_NOTES="Build: $TRAVIS_BUILD_NUMBER\nUploaded: $RELEASE_DATE"

# Travis now use Mavericks which requires the keychain is default and unlocked
# see: http://docs.travis-ci.com/user/common-build-problems/#Mac%3A-Code-Signing-Errors

# Make the keychain the default so identities are found
security default-keychain -s ios-build.keychain

# Unlock the keychain
security unlock-keychain -p travis ios-build.keychain

# Set keychain locking timeout to 3600 seconds
security set-keychain-settings -t 3600 -u ios-build.keychain

echo "Packagaing and deploying build to TestFlight"
rake deploy
