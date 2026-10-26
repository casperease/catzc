# pwsh/Tooling.Core/Uninstall-Tool.ps1

The uninstaller of one tool of `tools.yml` through the platform package manager, the counterpart of `Install-Tool`. It touches only tools
the expected manager owns.

## help

### synopsis

Uninstalls a tool using the platform package manager.

### description

Uses winget on Windows, brew on macOS, and apt-get on Linux. Skips if the tool is not installed.

### parameter `Tool`

The snake_case tool key as defined in tools.yml.

### parameter `Version`

Version override. Defaults to the locked version.

## npm-managed tools

npm-managed tools (cspell, prettier, markdownlint) are removed with npm, not a platform package manager. The command redirects to
`Uninstall-<command>` instead of failing later on a missing winget id.

## Which version

Uninstall targets the version that is actually installed, not the locked one. For tools whose package id embeds the version, such as node's
`OpenJS.NodeJS.{0}`, python's `Python.Python.{0}` and java's `Microsoft.OpenJDK.{0}`, defaulting to the locked version asks the package
manager to remove a package that is not there ("No installed package found") whenever the installed major differs, for example when
`Install-Tool -Force` replaces node 22 with the locked 24.

The installed version is reduced to the locked version's component granularity, so the `{0}` placeholder matches the installed package: node
`22.22.2` becomes `22`, python `3.11.9` becomes `3.11`. Version-independent ids (`Microsoft.AzureCLI`, `Hashicorp.Terraform`) ignore the
value. An explicit `-Version` still wins, for removing a named build.

## Managed tools only

Only tools managed by the expected package manager are uninstalled. A tool installed outside that control goes through its `Remove-<Tool>`.

## PATH cleanup

The command snapshots the User PATH before the uninstall to detect what the uninstaller removes. Winget uninstallers often remove their
registry PATH entries but leave the directories on disk, so `Test-Path` alone cannot tell stale from legitimate. Some uninstallers do the
reverse, removing the directory but leaving the PATH entry in the registry (Terraform does), and those entries are cleaned by checking that
the directory exists.
