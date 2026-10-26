# pwsh/Base.Exporter/tests/Build-Modules.Tests.ps1

The L0 tests of `Build-Modules`, with the build engine as a mocked boundary.

## The engine stub

The engine (`Catzc.Internal.Builder`) is loaded on demand. A stub makes its command exist for `Mock` when the engine module is not loaded in
the session.
