# pwsh/Base.Globs/tests/GlobSet-Independence.Tests.ps1

The integrity test of per-layer independence
([FDR-CD-GLOBS-NOOVERLAPWITHINLAYER](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-nooverlapwithinlayer)) in the real
repository.

## What it proves

Within every layer except the exempt one, no two globsets, declared or derived, select a common file on their own contribution. The
loose-fileset layer is exempt: its sets are cross-cutting check surfaces (a track's root concern, a scan scope, the reserved umbrellas) and
overlap by design. A module or deployable unit that starts containing part of a peer, such as a mis-scoped include or an umbrella declared
as a module, fails here, locally and in CI.

## Tier

It runs at L2 because the tracked-file universe comes from the real git CLI.
