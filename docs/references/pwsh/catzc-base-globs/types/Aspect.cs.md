# pwsh/Base.Globs/types/Aspect.cs

The aspect model: a unit's tracked files partition into named aspects that are pairwise disjoint and jointly exhaustive
([DDR-ASPECT](../../../../drs/design/module-aspects.md)). `CompiledAspect` is the result of compiling one aspect onto a unit root.

## The classification

The aspect set is the ordered first-match (fallthrough) classification carried by the `aspects` variant (`Catzc.Base.Variants`). Each aspect
claims by its patterns, and the last aspect is the `**` catch-all remainder and, by rule, non-live, so anything `live` does not explicitly
claim falls to the verification side and can never silently ship.

## Compilation onto a unit root

Compilation reuses the leaf scan program
([FDR-CD-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)). Aspect k becomes a
`GlobSet` with its include set to k's own patterns and its exclude set to every earlier aspect's patterns, all prefixed by the unit root. A
leaf program is the includes as `+` then the excludes as `-`, last match wins, which is exactly first-match slicing: a file is in aspect k
if it matches k's patterns and no earlier aspect's. Disjoint and exhaustive hold by construction, and `AspectPartition.Validate` re-checks
against a real file universe for the integrity gate.

## CompiledAspect

One aspect compiled onto a unit root: the name plus the leaf (include, exclude) rule sets that encode its first-match slice. PowerShell
(`Get-ModuleAspect`) builds the `GlobSet` from these.
