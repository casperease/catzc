# pwsh/Base.Contracts/Get-AccostedFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads an accosted file and checks every call in it against its command contract.

### description

An accosted file is a flat list of runs, each a list of harmless contracted calls
([ADR-AUTO-ACCOSTED](../../../drs/automation/accosted-language.md)). Each command must be named by a command contract and its verb must be
on the harmless-verb list of the accosted config; each argument must be a parameter of that contract and fit its type, and every mandatory
parameter outside a parameter set must be given. The first call that breaks a rule throws, naming the run and the command.

### parameter `Path`

The accosted file, absolute or relative to the repository root.

### parameter `RepositoryRoot`

The repository whose command contracts the calls are checked against. Default: Get-RepositoryRoot.

### outputs

`[Catzc.Base.Contracts.AccostedFile]` The file, every call checked.

### example 1

```powershell
(Get-AccostedFile pwsh/Catzc.Widget/tests/widget.accosted.yml).runs.Count
```
