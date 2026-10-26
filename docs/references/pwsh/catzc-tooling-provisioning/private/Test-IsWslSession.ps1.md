# pwsh/Tooling.Provisioning/private/Test-IsWslSession.ps1

A private helper of `Initialize-GitClone`: the test for a Linux session that runs inside WSL.

## help

### synopsis

Tests whether the current session runs inside WSL (Windows Subsystem for Linux).

### description

A WSL distribution sets WSL_DISTRO_NAME, and a WSL kernel identifies itself in /proc/version ("microsoft"). Either signal means the Linux
session is backed by a Windows host, so Windows-side tools are reachable under /mnt/c. Never true outside Linux.

### outputs

`[bool]`
