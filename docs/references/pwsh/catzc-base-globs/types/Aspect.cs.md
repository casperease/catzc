# pwsh/Base.Globs/types/Aspect.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Aspects ([DDR-ASPECT](/docs/drs/design/module-aspects.md)): a unit's tracked files partition into named aspects — pairwise DISJOINT
and jointly
EXHAUSTIVE. The aspect set is the ordered first-match ('fallthrough') classification carried by the
'aspects' variant (Catzc.Base.Variants): each aspect claims by its patterns, the LAST aspect is the '**'
catch-all remainder and by rule is non-live, so anything 'live' does not explicitly claim falls to the
verification side and can never silently ship.

Compilation onto a unit root reuses the leaf scan program
([FDR-CD-GLOBS-TRACKEDFILESONLY](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)): aspect k becomes a GlobSet with
Include = k's own patterns and Exclude = every EARLIER aspect's patterns (all prefixed by the unit root).
A leaf program is '+ includes' then '- excludes', last-match-wins — which is exactly first-match slicing:
a file is in aspect k iff it matches k's patterns and no earlier aspect's. Disjoint + exhaustive hold by
construction; AspectPartition.Validate re-checks against a real file universe for the integrity gate.
See [DDR-ASPECT](/docs/drs/design/module-aspects.md).
```

## comment:2

Above `public sealed class CompiledAspect`, written with `//`.

```text
One aspect compiled onto a unit root: the name plus the leaf (include, exclude) rule sets that encode its
first-match slice. PowerShell (Get-ModuleAspect) builds the GlobSet from these.
```
