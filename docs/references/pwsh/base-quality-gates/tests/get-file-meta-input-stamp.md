# pwsh/Base.QualityGates/tests/Get-FileMetaInputStamp.Tests.ps1

The tests of `Get-FileMetaInputStamp`, the stamp of the files beside a file that its meta block is read from.

## The engine stamp

The engine stamp is the input stamp over the files `FileMetaConfig.EngineInputs` names, so the tests mock `Get-InputStamp` and let a fixture
value stand for it.
