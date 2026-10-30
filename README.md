# RM6785 Kernel Build Workflow

[![GitHub Actions Workflow](https://img.shields.io/badge/GitHub%20Actions-Workflow-blue?logo=githubactions)](https://github.com/elohim-etz/Kernel_Action_Builder/actions)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20(RM6785)-orange)](https://github.com/elohim-etz/Kernel_Action_Builder)

An automated, highly customizable GitHub Actions workflow for building RM6785 kernels with optional KernelSU and SUSFS support.

---

## Table of Contents

- [Features](#features)
- [Supported Devices](#supported-devices)
- [Setup](#setup)
- [Usage](#usage)
- [Build Naming Convention](#build-naming-convention)
- [Important Notes](#important-notes)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Multiple KernelSU Variants**: Native support for `xxKSU`, `SukiSU`, and `BakaSU`.
- **SUSFS Integration**: Optional SUSFS support for enhanced stealth and security.
- **Stock Builds**: Option to build a clean, stock kernel without KernelSU.
- **Automated Notifications**: Receive build success/failure alerts directly via Telegram.
- **Optimized Build Times**: Utilizes `ccache` to significantly speed up subsequent builds.
- **Ready-to-Flash Packaging**: Automatically packages the compiled kernel using AnyKernel3.
- **Artifact Uploads**: Direct download links for build artifacts via GitHub Actions.

---

## Supported Devices

This workflow is specifically tailored for the MediaTek Helio G90T (RM6785) platform, including:

- Realme 6
- Realme 6i
- Realme 6s
- Realme 7
- Realme Narzo
- Realme Narzo 20 Pro
- Realme Narzo 30 4G

---

## Setup

### 1. Fork or Create Repository
Fork this repository or create a new one to host your custom build workflow.

### 2. Configure GitHub Secrets
To enable automated Telegram notifications, you need to add the following secrets to your repository:
1. Navigate to **Settings** > **Secrets and variables** > **Actions**.
2. Click **New repository secret** and add:
   - `TELEGRAM_BOT_TOKEN`: Your Telegram bot token (obtain from [@BotFather](https://t.me/BotFather)).
   - `TELEGRAM_CHAT_ID`: Your Telegram chat ID or channel username (e.g., `@your_channel` or `-1001234567890`).

### 3. Customize Workflow (Optional)
Modify the `.github/workflows/build-kernel.yml` file to suit your specific needs. Default values include:
- **Defconfig**: `RM6785_defconfig`
- **Clang Toolchain**: `AOSP` (Options: `AOSP`, `Neutron`)
- **ZIP Name Prefix**: `Yuri` (Can be changed to your preferred name)
- Kernel source repository and branch
- AnyKernel3 repository and branch

---

## Usage

### Manual Build Trigger
1. Navigate to the **Actions** tab in your GitHub repository.
2. Select the **Build RM6785 Kernel** workflow from the left sidebar.
3. Click the **Run workflow** dropdown button.
4. Configure the build parameters:
   - **Kernel Branch**: The target branch of your kernel source (e.g., `main`, `master`, `lineage-21.0`).
   - **Enable KernelSU**: Check this box to integrate KernelSU.
   - **KernelSU Variant**: Select your preferred variant (`xxKSU`, `SukiSU`, or `BakaSU`). *Only visible if KSU is enabled.*
   - **Enable SUSFS**: Check this box to enable SUSFS. *Only works with compatible KSU variants.*
   - **Custom Build Note**: (Optional) Add a custom note to identify this specific build (e.g., "Test build with custom governors"). This note will be included in the Telegram notification.

---

## Build Naming Convention

Output artifacts are automatically named based on your selected configuration to ensure easy identification:

| Build Type | Naming Format | Example |
|------------|---------------|---------|
| **Stock** (No KSU) | `{Prefix}-RM6785-Stock-YYYYMMDD-HHMM.zip` | `Yuri-RM6785-Stock-20241218-1430.zip` |
| **KSU** (No SUSFS) | `{Prefix}-RM6785-{VARIANT}-YYYYMMDD-HHMM.zip` | `Yuri-RM6785-SukiSU-20241218-1430.zip` |
| **KSU + SUSFS** | `{Prefix}-RM6785-{VARIANT}-SUSFS-YYYYMMDD-HHMM.zip` | `Yuri-RM6785-SukiSU-SUSFS-20241218-1430.zip` |

*(Note: The `Yuri` prefix can be changed in the workflow file via the `zip_name` input.)*

---

## Important Notes

- **SUSFS requires KernelSU**: SUSFS cannot be enabled on a stock build.
- **xxKSU and SUSFS incompatibility**: The `xxKSU` variant does not support SUSFS. If selected, the SUSFS flag will be automatically ignored by the workflow.
- **SukiSU & BakaSU**: These variants have full, tested support for SUSFS integration.

---

## Troubleshooting

- **Build fails immediately**: Verify that your kernel branch name is correct and that the repository is public (or that you have configured a `private_repo_token` for private repos).
- **No Telegram notification**: Double-check your `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` in repository secrets. Ensure the bot has permission to send messages to the target chat/channel.
- **SUSFS not applying**: Ensure you have selected a SUSFS-compatible KernelSU variant (`SukiSU` or `BakaSU`).

---

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to open a pull request to improve the workflow, add new device support, or enhance the documentation.

---

## License

This project is licensed under the [MIT License](LICENSE). 

---
*Built for the RM6785 custom ROM and kernel community.*
