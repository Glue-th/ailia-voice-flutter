# ailia Voice Flutter Package

!! CAUTION !!
“ailia” IS NOT OPEN SOURCE SOFTWARE (OSS).
As long as user complies with the conditions stated in [License Document](https://ailia.ai/license/), user may use the Software for free of charge, but the Software is basically paid software.

## About ailia Voice

ailia AI Voice is a library for speech synthesis using AI. It provides APIs for C# for Unity and for C for native applications. By using ailia AI Voice, it is possible to easily implement AI-based speech synthesis in applications.

ailia AI Voice can perform speech synthesis offline, only on edge devices, without the need for cloud connectivity. It also supports the latest GPT-SoVITS, enabling speech synthesis in any voice timbre.

## API specification

https://github.com/axinc-ai/ailia-sdk

## Build App

```bash
cd example/ios
```

### Install Gem

```bash
bundle install
```

### Install Fastlane

```bash
brew install fastlane
```

### Create `.env.secret` in `example/ios/fastlane`

1. Provide the application specific password using the environment variable `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`

   1.1. Visit https://appleid.apple.com/account/manage

   1.2. Generate a new application specific password

2. Provide the Apple email address using the environment variable `APPLE_ID`

```bash
APPLE_ID="Your Apple email address"
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="Your application specific password"
```

### Run

```bash
fastlane build
```
