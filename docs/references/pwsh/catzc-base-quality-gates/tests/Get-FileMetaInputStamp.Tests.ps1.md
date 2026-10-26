# pwsh/Base.QualityGates/tests/Get-FileMetaInputStamp.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-InputStamp -ModuleName Catzc.Base.QualityGates { $script:engine }`, written with `#`.

```text
The engine stamp is the input stamp over the files FileMetaConfig.EngineInputs names; a fixture stands for its
value here.
```
