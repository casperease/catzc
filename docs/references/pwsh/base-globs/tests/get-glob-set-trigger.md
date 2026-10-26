# pwsh/Base.Globs/tests/Get-GlobSetTrigger.Tests.ps1

The tests of `Get-GlobSetTrigger`, the projection of a globset's scan program into vendor-native path filters
([FDR-CD-GLOBS-NAMEDGLOBSETS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-namedglobsets)).

## What it proves

GitHub gets ordered `!` negation paths, which are exact. Azure DevOps gets order-independent include and exclude lists, with each pattern
collapsed to its last select.

## Fixtures

A base drops `configuration/*/**` and a unit re-adds its own `configuration/widget/**` on top. GitHub keeps the ordered program, where the
last match wins. Azure DevOps collapses each pattern to its last select, so the re-add is an include and the broader drop stays an exclude,
with no contradictory pattern. The composition is built through `GlobsConfig`, the real path, since `ResolveCompose` is internal.

The shared-platform shape is covered too: the base excludes `configuration/*.yml` and the unit re-adds the identical pattern. The last
select wins, so the pattern is an Azure DevOps include only, never both an include and an exclude.
