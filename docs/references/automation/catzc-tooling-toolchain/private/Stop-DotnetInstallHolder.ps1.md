# automation/Catzc.Tooling.Toolchain/private/Stop-DotnetInstallHolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Stops exactly the named processes that hold a .NET install open, then asserts the install is free.

### description

Stops each holder Get-DotnetInstallHolder named — by process id, nothing else — and waits for it to exit,
so its handles on the install are released. A process that already exited is skipped. Refuses to stop the
calling session itself. Throws when the install is still held afterwards (a process restarted, or a new
holder appeared).

### parameter InstallDir

The .NET install directory.

### parameter Holder

The holders to stop, as Get-DotnetInstallHolder returned them.
