# pwsh/Catzc.Tooling.Provisioning/private/Test-IsWslSession.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether the current session runs inside WSL (Windows Subsystem for Linux).

### description

A WSL distribution sets WSL_DISTRO_NAME, and a WSL kernel identifies itself in /proc/version ("microsoft"). Either signal means the Linux
session is backed by a Windows host, so Windows-side tools are reachable under /mnt/c. Never true outside Linux.

### outputs

`[bool]`
