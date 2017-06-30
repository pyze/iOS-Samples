#!/bin/bash -ex
SCRIPT_DIRECTORY=`dirname "$0"`
ROOT_PATH=`dirname "${0}"`/../

VERSION=$1

if [ -z "$1" ]
  then
    echo "No version number supplied"
    exit
fi

# Pods
sed -i '' "s/\(s.version *= *\)\".*\"/\1\"$VERSION\"/g" $ROOT_PATH/UrbanAirship-iOS-SDK.podspec
sed -i '' "s/\(s.version *= *\)\".*\"/\1\"$VERSION\"/g" $ROOT_PATH/UrbanAirship-iOS-AppExtensions.podspec

# Airship Config
sed -i '' "s/\CURRENT_PROJECT_VERSION.*/CURRENT_PROJECT_VERSION = $VERSION/g" $ROOT_PATH/AirshipKit/AirshipConfig.xcconfig

# UAirshipVersion.m
sed -i '' "s/\(versionString *= *@\)\".*\"/\1\"$VERSION\"/g" $ROOT_PATH/AirshipKit/AirshipKit/UAirshipVersion.m



