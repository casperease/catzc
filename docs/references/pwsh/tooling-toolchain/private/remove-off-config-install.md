# pwsh/Tooling.Toolchain/private/Remove-OffConfigInstall.ps1

The shared body of a tool's `Remove-<Tool>`: it evicts an install the tooling system does not manage, by the install's own mechanism, and
refuses the managed one, which is `Uninstall-<Tool>`'s.

## help

### synopsis

Removes an off-config install of a tool, previewing unless -Force is given.

### description

On Linux and macOS it evicts the off-config install on PATH through the platform's remover. On Windows it refuses the managed install, runs
the uninstallers of the Windows-registered products that own a machine folder (bundles first, up to three rounds, each transcribed under the
output folder), then deletes the folder and its machine PATH entry. Without -Force it only says what it would do, and with registered
products it prints the uninstall commands to paste. Administrator is asserted only for the steps that need it.

### parameter `Config`

The tool's tools.yml entry.

### parameter `Label`

The tool's name in messages: '.NET', 'Go'.

### parameter `Tool`

The tool's command suffix: Remove-`<Tool>` and Uninstall-`<Tool>`.

### parameter `InstallDir`

The install folder to remove.

### parameter `MachineFolders`

The machine-wide folders a registered installer may own.

### parameter `ProductPattern`

The DisplayName pattern of the tool's Windows-registered products.

### parameter `ExtraPathDirs`

Further PATH entries to remove with the folder.

### parameter `EnvironmentVariables`

Environment variables to remove with the folder.

### parameter `Force`

Execute the removal; without it, only report what would be removed.
