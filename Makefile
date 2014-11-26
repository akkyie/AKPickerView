PROJECT = AKPickerViewSample.xcodeproj
TEST_TARGET = AKPickerViewSample

clean:
  xcodebuild \
      -project $(PROJECT) \
      clean

test:
  xcodebuild \
      -project $(PROJECT) \
      -target $(TEST_TARGET) \
      -sdk iphonesimulator \
      -configuration Debug