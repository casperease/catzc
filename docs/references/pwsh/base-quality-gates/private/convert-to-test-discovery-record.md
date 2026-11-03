# pwsh/Base.QualityGates/private/ConvertTo-TestDiscoveryRecord.ps1

Reduces the discovered tests of one test file to the plain record that Get-TestDiscovery stores in its cross-session file.

## help

### synopsis

Converts the Pester tests of one file into a storable discovery record.

### description

The record holds the distinct blocks of the tests, each once and told apart by its expanded path and tags, with the parent of a block named
by index, and one entry per test with its name, path, tags, start line and block index. A Go bridge test, whose script file differs from the
test folder Get-TestRunFile reports, also carries that file and folder in the record. Get-TestDiscovery saves the record in
out/cache/test-discovery.json, and ConvertTo-TestDiscoveryRow turns it back into rows.

### parameter `Test`

The discovered Pester tests of one test file; an empty set gives a record with no blocks and no tests.

### outputs

A hashtable with the keys blocks and tests, and the keys file and testFolder for a Go bridge test.
