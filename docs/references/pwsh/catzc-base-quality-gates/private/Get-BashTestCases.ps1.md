# pwsh/Base.QualityGates/private/Get-BashTestCases.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the Bash tests a Bash test folder declares, read from its .bats files without running bats.

### description

The language bridge's discovery for Bash: Pester discovers the bridge's tests before anything runs, so the Bash tests are read from the
source text, never from bats — discovery stays fast and offline, and works where bash is missing (the tests then skip). Every `*.bats` file
below the folder counts, except under a folder whose name starts with '.' or '_'. A Bash test is a line `@test "<name>" {` (or with the name
in single quotes), as bats declares it.

Each case carries its package: the file's path inside the folder, '/'-separated (repository.bats, or nested/widget.bats), which pairs it
with the BashTestResult Invoke-BashTest returns. The category follows the BashTestResult rule: a name starting with "integrity:" is
integrity, everything else logic.

### parameter `Folder`

The absolute path of the Bash test folder (a Get-LanguageTestFolders Folder).

### outputs

`[pscustomobject]` One case per Bash test ({ Key; Package; Name; Category; Title }), files in ordinal order and each file's tests in
declaration order. Key is '`<Package>` `<Name>`'; Title is the name, prefixed with the package when two files declare the same name.

### example 1

```powershell
Get-BashTestCases -Folder (Get-LanguageTestFolders | Where-Object Language -EQ bash)[0].Folder
```
