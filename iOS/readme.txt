PON iOS App

DEBUG TIME FUNCTION SCRIPT

xcodebuild -workspace PonApp.xcworkspace -scheme PonApp clean build OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" | grep [1-9].[0-9]ms | sort -nr > culprits.txt