#!/bin/bash
set -e

echo "📦 Installing system dependencies (Java 17, unzip, wget)..."
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk unzip curl wget

echo "⚙️ Configuring environment variables..."
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=$HOME/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# Persist variables for future terminal sessions
cat << EOF >> ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=\$HOME/android-sdk
export PATH=\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools:\$PATH
EOF

echo "📥 Downloading Android Command Line Tools..."
mkdir -p $ANDROID_HOME/cmdline-tools
# Using a stable, widely-tested CLI tools version
TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
wget -q $TOOLS_URL -O /tmp/cmdline-tools.zip

echo "📂 Extracting and structuring SDK tools..."
unzip -q /tmp/cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools
mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest
rm /tmp/cmdline-tools.zip

echo "📜 Accepting Android SDK licenses..."
yes | sdkmanager --licenses

echo "🛠 Installing Android 34 platform & build tools..."
sdkmanager "platforms;android-34" "build-tools;34.0.0"

echo "🧹 Cleaning up SDK cache..."
sdkmanager --cleanup

echo "🌍 Installing react-native-cli globally..."
npm install -g react-native-cli

echo "✅ Setup complete! Open a new terminal or run 'source ~/.bashrc' to apply paths."
