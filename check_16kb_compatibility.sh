#!/bin/bash

# 16KB Page Size Compatibility Checker
# This script checks if your APK is compatible with 16KB page sizes

echo "=========================================="
echo "16KB Page Size Compatibility Checker"
echo "=========================================="

# Check if APK file exists
APK_FILE=""
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    APK_FILE="build/app/outputs/flutter-apk/app-release.apk"
elif [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    APK_FILE="build/app/outputs/flutter-apk/app-debug.apk"
else
    echo "❌ No APK file found. Please build your app first."
    exit 1
fi

echo "📱 Checking APK: $APK_FILE"

# Check dependencies
echo "🔍 Checking dependencies..."
if ! command -v unzip &> /dev/null; then
    echo "❌ unzip is required but not installed."
    exit 1
fi

if ! command -v objdump &> /dev/null; then
    echo "❌ objdump is required but not installed."
    exit 1
fi

# Extract and check native libraries
echo "📦 Extracting native libraries..."
TEMP_DIR=$(mktemp -d)
unzip -q "$APK_FILE" -d "$TEMP_DIR"

echo "🔍 Checking ELF alignment..."
FAILED_LIBS=()
PASSED_LIBS=()

for lib in $(find "$TEMP_DIR" -name "*.so"); do
    # Get the architecture from the path
    arch=$(echo "$lib" | grep -o 'arm64-v8a\|armeabi-v7a\|x86_64\|x86' | head -1)
    
    # Check ELF alignment
    alignment=$(objdump -p "$lib" 2>/dev/null | grep -E "LOAD.*align" | head -1 | grep -o "2\*\*[0-9]*" | head -1)
    
    if [ -n "$alignment" ]; then
        # Convert alignment to number
        align_num=$(echo "$alignment" | sed 's/2\*\*//')
        if [ "$align_num" -ge 14 ]; then
            echo "✅ $(basename "$lib") ($arch): $alignment - PASS"
            PASSED_LIBS+=("$(basename "$lib")")
        else
            echo "❌ $(basename "$lib") ($arch): $alignment - FAIL"
            FAILED_LIBS+=("$(basename "$lib")")
        fi
    else
        echo "⚠️  $(basename "$lib") ($arch): Could not determine alignment"
    fi
done

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "=========================================="
echo "📊 SUMMARY"
echo "=========================================="
echo "✅ Passed: ${#PASSED_LIBS[@]} libraries"
echo "❌ Failed: ${#FAILED_LIBS[@]} libraries"

if [ ${#FAILED_LIBS[@]} -eq 0 ]; then
    echo ""
    echo "🎉 SUCCESS: Your app is 16KB compatible!"
    echo "✅ Ready for Google Play submission"
else
    echo ""
    echo "⚠️  WARNING: Your app is NOT 16KB compatible"
    echo "❌ Failed libraries:"
    for lib in "${FAILED_LIBS[@]}"; do
        echo "   - $lib"
    done
    echo ""
    echo "🔧 To fix this:"
    echo "1. Update to NDK 27 or higher"
    echo "2. Use Mapbox NDK 27 artifacts"
    echo "3. Ensure proper CMake configuration"
    echo "4. Rebuild your app"
fi

echo ""
echo "📚 For more information:"
echo "https://developer.android.com/guide/practices/page-sizes"
