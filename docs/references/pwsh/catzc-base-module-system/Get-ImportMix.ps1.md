# pwsh/Base.ModuleSystem/Get-ImportMix.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the session's import mix: the languages, engines and modules the importer decided.

### description

The one record of the mix ([ADR-AUTO-IMPORTER](../../../drs/automation/importer.md)). The importer resolves it once after loading the
modules (Set-ImportMix) and keeps it for the session, and the test runner and the builder read it here instead of deciding again. A session
the importer did not finish resolves it once from the configuration, with no caller values, and keeps that.

### outputs

`[Catzc.Base.ModuleSystem.ImportMix]` The languages, engines and modules of the session, with the engines and the modules left out.

### example 1

```powershell
(Get-ImportMix).engines
```

## comment:1

Above `$recorded =...`, written with `#`.

```text
The record the importer set for the session; a session the importer did not finish resolves it from the
configuration once.
```
