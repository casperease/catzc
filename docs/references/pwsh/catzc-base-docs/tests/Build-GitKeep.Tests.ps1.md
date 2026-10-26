# pwsh/Base.Docs/tests/Build-GitKeep.Tests.ps1

The tests of `Build-GitKeep`, in three blocks: the logic over a fixture tree, the shipped asset, and the repository's own `.gitkeep` files.

## Logic

The repository root is redirected to a fixture tree (TestKit) so the walk and the writes bind inside it. The tree holds one stale
`.gitkeep`, one nested one, one deep inside `out/`, which must never be touched (the walk checks `out/.gitkeep` itself but does not
descend), and one under a vendored module, which is not ours to manage. The source comes through the asset seam as a fixture text, so the
logic never reads the shipped asset.

## Shipped asset

This block reads the shipped `assets/gitkeep` through `Build-GitKeep`'s real lookup, with nothing mocked on the read, and writes only into a
fixture repository, so it runs in both the source run and the build run
([ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)).
`-WorkingRootOnly` puts the `.gitkeep` files in the fixture working root while the asset under test stays the one shipped in the loaded
module, so the code root stays on the loaded modules.

## Managed files

The last block reads only the repository's own `.gitkeep` files and `readme.yml` mappings. It gives the same answer in both run modes, so
the build run skips it.
