# automation/Catzc.Base.QualityGates/private/Write-TestRunLockRecord.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes the record that names who holds a test-run lock.

### description

A lock (the working folder's, Enter-TestRunLocation; the user's system-test lock, Enter-SystemTestLock) says only that it is held; the
record beside it says by whom, so a run that finds the lock held can name the holder (Get-TestRunLockHolder) instead of guessing. The record
carries the holder's pid and process start time (a reused pid is told apart), the entry point, when it started, its run folder and its
working folder. The write is atomic — a temp file moved over the record — so a reader never sees half of it.

### parameter `Path`

The record file. Its folder is created when missing.

### parameter `EntryPoint`

The entry point holding the lock ('Test-Automation', 'Invoke-TestFile', …).

### parameter `RunDirectory`

The holder's run folder.

### parameter `RepositoryRoot`

The holder's working folder — what tells two checkouts apart for a user-wide lock.

### outputs

None.

### example 1

```powershell
Write-TestRunLockRecord -Path $lockPath -EntryPoint 'Test-Automation' -RunDirectory $runDir -RepositoryRoot $root
```
