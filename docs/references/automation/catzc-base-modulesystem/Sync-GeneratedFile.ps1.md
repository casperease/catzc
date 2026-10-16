---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "407e748d1a27"
    adrs:
      - ADR-AUTO-CACHE#8
---

# automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })`, written with `#`.

```text
Which generated paths actually changed decides both the commit's pathspec and its message — the
stamp commit stages and names exactly what this sync did, never a sibling path that was clean.
```

## comment:2

Above `if ($changed -contains 'automation/.compiled') {`, written with `#`.

```text
.compiled must hold exactly the current build
([ADR-AUTO-CACHE#8](/docs/adr/automation/caching.md#rule-adr-auto-cache8)). A superseded DLL that
survived the
janitor (a session still holds it) would otherwise be committed next to the new one — the +1 without
the -1. Hold the .compiled commit back until it is tidy; any other changed generated path still commits.
```

## comment:3

Above `if ($changed -contains 'automation/.compiled' -and (Test-GitPathChanged...`, written with `#`.

```text
The build is named for the hash of the working-tree type sources. While any of them differs from HEAD — often
another session's in-flight edit — committing it would leave HEAD carrying a build its own sources do not
produce. Hold .compiled back until the sources are committed.
```
