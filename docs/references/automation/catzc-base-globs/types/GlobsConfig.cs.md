---
catzc:
  immutable:
    with_body_sha: e428f4876a58
    path: docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md
    folder: docs/references/automation/catzc-base-globs/types
    name: globs-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-FLOW-CD-GLOBS#{7,8}
---

# automation/Catzc.Base.Globs/types/GlobsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The globset registry (configs/globs.yml) and its validity rules: a non-empty 'globsets' map of
kebab-case name -> { description, layer (deployable-unit | loose-fileset — 'module' is derived-only and
rejected here, [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)), [include: [...]], [exclude: [...]],
[compose: [...]],
[verify: { modules, level }], [pipeline] }, each entry a valid GlobSet, no unknown keys anywhere
(strict-config discipline), and compose references resolving to declared sets acyclically
([ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)).
The config itself is an ordinary tracked file and may be a member. Constructing an instance validates the
whole registry (collecting all errors) and exposes the sets in registry order.
See [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md).
```

## comment:2

Above `public static readonly string[] ReservedNames = { "internal", "vendor",...`, written with `//`.

```text
Names reserved for the DERIVED globsets
([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): the infra scopes every module's tests depend
on. Module folders derive their own sets by convention (Get-ModuleGlobSet); a declared set may not
shadow a reserved name — the declared registry and the derived sets share one name space.
```

## comment:3

Above `foreach (GlobSet set in sets)`, written with `//`.

```text
---- compose resolution ([ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)): every reference
names a declared set, never itself, and
     the reference graph is acyclic; effective membership is the union through the references. ----
```

## comment:4

Above `if (errors.Count > 0)`, written with `//`.

```text
A broken compose graph makes Matches() unsafe (a cycle would recurse forever), so fail now with
everything collected so far — the final validation gate.
```

## comment:5

Above `private static string FindComposeCycle(GlobSet set, Dictionary<string,...`, written with `//`.

```text
Depth-first walk of the compose references; returns the cycle path when one exists, else null.
Guarded against unresolved references (already reported) by walking the name map only.
```
