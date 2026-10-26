# pwsh/.scriptanalyzer/NoUnboundedEnumeration.psm1

The custom analyzer check `Measure-NoUnboundedEnumeration`: folders and files are listed through `Get-ChildPath`, never by a filesystem
cmdlet or an unbounded walk. It flags `Get-ChildItem` and its aliases on a filesystem path, and `[System.IO.SearchOption]::AllDirectories`;
test files are covered too.

## Provider paths

A literal provider path (`env:`, `function:`, `HKLM:`) lists a provider, not the filesystem, and is not flagged. A drive name of one letter
is a filesystem drive.
