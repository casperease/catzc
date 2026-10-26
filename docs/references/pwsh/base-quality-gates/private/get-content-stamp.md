# pwsh/Base.QualityGates/private/Get-ContentStamp.ps1

The fingerprint of a set of input files: one SHA-256 over a label and each file's repository-relative path and content hash. A check's
result cache keys a file on its own hash and on this stamp of everything else that decides the verdict.

## help

### synopsis

The fingerprint of a set of input files: one SHA-256 over a label and each file's path and content hash.

### description

A quality check's result cache keys each file on its own SHA-256 and this stamp of everything else that decides the check's verdict
([ADR-AUTO-CACHE-CROSSSESSIONFILES](../../../../drs/automation/caching.md#rule-adr-auto-cache-crosssessionfiles)). A missing input hashes as
missing, so adding, editing or removing one changes the stamp, and every cached verdict of that check is checked again. The files are
fingerprinted in the given order under their repository-relative paths, so the stamp is the same on every clone.

A PowerShell input (.ps1, .psm1, .psd1 — an analyzer rule, a settings file) is fingerprinted by its tokens without its comments: a comment
never decides a verdict, and comments in rule files change often (an ADR citation sweep rewrites them), which would otherwise send every
file back through the check. Every change to the code itself still changes the stamp. A PowerShell file that does not parse, and every other
input, is fingerprinted by its bytes.

### parameter `Label`

What the stamp is for (an engine or check name); two checks never share a stamp.

### parameter `File`

The input files, absolute paths.

### parameter `RepositoryRoot`

The root the paths are recorded relative to.

### outputs

`[string]` A hex SHA-256.

## comments and line ends

A PowerShell input is hashed by its tokens, so its comments are left out. A run of line ends, which is what a removed comment line leaves,
counts as one: a line end separates statements but a blank line does not. A change to the code itself still changes the stamp.
