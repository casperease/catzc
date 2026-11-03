# pwsh/Base.QualityGates/private/Get-TestDiscoveryFile.ps1

Expands one test path of Get-TestDiscovery into the test files it covers.

## help

### synopsis

Returns the test files under a path.

### description

A folder gives the Tests.ps1 files under it, to a depth of three folders. A file, or a path that does not exist, is returned as given, so
that Pester reports what is wrong with it. Get-TestDiscovery keys each returned file on its path and content digest in the discovery cache.

### parameter `Path`

A test folder or a test file.

### outputs

The paths of the test files, as strings.
