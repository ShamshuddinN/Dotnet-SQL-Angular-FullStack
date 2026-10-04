# DAB CLI Installation Issue - Root Cause & Fix

## Issue Summary

Attempting to install the Data API Builder (DAB) CLI globally using the command:
```bash
dotnet tool install --global Microsoft.DataApiBuilder
```

Resulted in the following error:
```
Skipping NuGet package signature verification.
The settings file in the tool's NuGet package is invalid: Settings file 'DotnetToolSettings.xml' was not found in the package.
Tool 'microsoft.dataapibuilder' failed to install. Contact the tool author for assistance.
```

## Root Cause Analysis

1. **.NET SDK Version Mismatch**
   - The system has .NET SDK 8.0.131 installed (`dotnet --version` returns `8.0.131`)
   - Runtime: `Microsoft.NETCore.App 8.0.31` and `Microsoft.AspNetCore.App 8.0.31`

2. **Latest Package Targets .NET 10**
   - The latest stable version of `Microsoft.DataApiBuilder` is `2.1.5` (confirmed via NuGet API)
   - Inspection of the `2.1.5` nupkg revealed:
     - `DotnetToolSettings.xml` is located at `tools/net10.0/any/DotnetToolSettings.xml`
     - The nuspec shows no net8.0 tool assets
   - This causes `dotnet tool install` to fail on systems with only .NET 8 SDK

3. **Version Compatibility Boundary**
   - Versions `2.1.0-rc` and `2.1.3-rc` also target `.NET 10` (`tools/net10.0/any/`)
   - Versions `2.0.12` and earlier (including `1.7.93`, `2.0.11`) target `.NET 8` (`tools/net8.0/any/`)
   - The last .NET 8-compatible stable release is **`2.0.12`**

## Fix Approach

### 1. Install Compatible Version

Install the DAB CLI pinned to the .NET 8-compatible version:

```bash
dotnet tool install --global Microsoft.DataApiBuilder --version 2.0.12
```

This succeeds because the package contains the required `DotnetToolSettings.xml` under `tools/net8.0/any/`.

### 2. Configure PATH Environment Variable

The installation warns that `~/.dotnet/tools` is not in PATH. To make it persistent across shell sessions, add the following to `~/.bashrc`:

```bash
# .NET Core SDK tools
if [ -d "$HOME/.dotnet/tools" ] && ! [[ "$PATH" =~ "$HOME/.dotnet/tools:" ]]; then
    export PATH="$HOME/.dotnet/tools:$PATH"
fi
```

Apply to current session:
```bash
source ~/.bashrc
```

### 3. Verify Installation

```bash
which dab
# Output: /home/shams/.dotnet/tools/dab

dab --version
# Output: Microsoft.DataApiBuilder 2.0.12+0b38aa7cbf4118034ad8dee1f2712b1c4bac4c32

dotnet tool list --global
# Shows: microsoft.dataapibuilder 2.0.12
```

## Conclusion

The installation failure was due to a .NET SDK/tooling TFM mismatch between the host (.NET 8) and the latest DAB CLI package (.NET 10). The solution is to pin to the last compatible stable version (`2.0.12`) until upgrading to .NET 10 SDK.

If a .NET 10 SDK is installed in the future, the latest version (`2.1.5`) can be installed without pinning.
