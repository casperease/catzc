# pwsh/Base.ModuleSystem/tests/New-Importer.Tests.ps1

The tests of `New-Importer`, including the drift guards for the committed `importer.ps1`, which is generated from the `Invoke-Importer`
overlay.

## Drift guards

Two guards cover the two ways the committed file can drift. Its parameter set must equal the overlay's, where the signature is the parameter
set and no tagging is involved. Its whole content below its generated-file head must equal the output of `New-Importer`. To fix a failure,
run `Build-RootConfig` and commit `importer.ps1`.

## Signature helper

`Get-ParamSignature` builds the `<name> [<type-as-written>]` list of a parameter block, either the script's own or a named function's inside
a module file. It parses the source, so the overlay need not be loaded.
