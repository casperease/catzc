# pwsh/Base.Files/types/RestartManager.cs

The binding to the Windows Restart Manager (`rstrtmgr.dll`), which says which processes hold a file open: the API behind Explorer's "file in
use by ..." dialog. `Get-FileLockingProcess` calls it.

## What it sees

It needs no admin rights and sees both an open handle and a mapped (loaded) DLL image.

## Platforms

The P/Invoke binds lazily, so the type loads on every platform, but `GetHolders` must only be called on Windows: elsewhere it throws
`PlatformNotSupportedException`.
