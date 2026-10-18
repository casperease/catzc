# automation/Catzc.Base.TypesSystem/private/Stop-FileLockingProcess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Stops the processes holding a file open, so the file can be deleted — the type-cache kill switch.

### description

Asks Get-FileLockingProcess who holds the file and stops each holder, waiting briefly for it to exit so its handle is released. Every stop
is announced, naming the process and the file, because stopping a process can lose its unsaved work. Never stopped: this session ($PID) and
every ancestor of it — the terminal, the editor host, or the shell that launched this session; stopping one of those would end the very
session asking. Such a holder is reported instead, for the caller's error to name. A process that cannot be stopped (another user's, or an
elevated one) is reported and left. On a host without mandatory file locking there are no holders, and this does nothing.

### parameter Path

The file whose holders to stop.

### outputs

None.
