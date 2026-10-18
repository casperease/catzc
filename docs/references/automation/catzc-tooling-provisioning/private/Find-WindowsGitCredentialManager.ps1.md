# automation/Catzc.Tooling.Provisioning/private/Find-WindowsGitCredentialManager.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Locates the Windows Git Credential Manager from inside a WSL session.

### description

Probes the known Windows-side install locations under /mnt/c — the system-wide Git for Windows
install, and the per-user portable install Install-Git produces under LOCALAPPDATA — for the
credential-manager executable (git-credential-manager.exe; the -core suffix on older Git for
Windows releases). Returns the first existing path, or $null when none exists (git is not
installed on the Windows side).

### outputs

`[string]` The Windows-side executable path as WSL sees it, or $null.
