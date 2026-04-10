#! /bin/bash

set -euxo pipefail

f1Key="0x70000003A"
f2Key="0x70000003B"
keyboardBrightnessDownKey="0xFF00000009"
keyboardBrightnessUpKey="0xFF00000008"

hidutil property --set "{\"UserKeyMapping\": [
  {
    \"HIDKeyboardModifierMappingSrc\": $f1Key,
    \"HIDKeyboardModifierMappingDst\": $keyboardBrightnessDownKey
  },
  {
    \"HIDKeyboardModifierMappingSrc\": $f2Key,
    \"HIDKeyboardModifierMappingDst\": $keyboardBrightnessUpKey
  }
]}"