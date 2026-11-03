# pwsh/Base.QualityGates/private/ConvertTo-TestDiscoveryRow.ps1

Rebuilds the rows of one test file from the record that Get-TestDiscovery read back from its cross-session file.

## help

### synopsis

Converts a stored discovery record back into test rows.

### description

Each row carries the members the readers of Get-TestDiscovery use: Tag, Block (Tag, IsRoot, Parent), ScriptBlock (File,
StartPosition.StartLine), ExpandedName, ExpandedPath, Result, Duration and ErrorRecord. The blocks are rebuilt from the root down through
the parent indexes of the record, and every row has the result NotRun, as nothing executed. A record of a Go bridge test gives its blocks
the container data that names the test folder. The record is the one ConvertTo-TestDiscoveryRecord wrote to out/cache/test-discovery.json.

### parameter `Record`

The stored discovery record of one test file.

### parameter `File`

The repository-relative path of the test file, used as the script file of the rows unless the record names its own.

### outputs

One row per test of the record, in the order they were stored.
