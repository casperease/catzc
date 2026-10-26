# pwsh/Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1

The test of parity between the source and the build
([DDR-RUNMODE-SAMEMODULEINBOTH](../../../../drs/design/run-modes.md#rule-ddr-runmode-samemoduleinboth)): every built module is the same
module as its source folder. Its exported command set equals the folder's public function files, and its private function set equals the
folder's `private/` files. `Test-BuildArtifact` reads the source side from the files and the build side from the modules as a build-mode
session actually loads them.

The test is source-only: it compares the source tree with a fresh build of it, entered in its own child pwsh, so the answer does not depend
on the mode of the session running it. It is greedy, because it costs one full build plus one importer-loading child pwsh.
