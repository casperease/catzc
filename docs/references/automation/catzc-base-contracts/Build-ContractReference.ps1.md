# automation/Catzc.Base.Contracts/Build-ContractReference.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$inputsSha = Get-InputStamp -Root $RepositoryRoot -Path @(`, written with `#`.

```text
The assets, this module and the paragraph filler are the whole input: when every page this writer emitted already carries
their stamp, nothing is read or written. A unit added or removed changes the assets, so its stamp moves and every page rebuilds.
```
