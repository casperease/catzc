---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Assert-CatzcBundle.ps1.md
    kind: comment-page
    body_sha: "40d0fcc275a2"
    adrs:
      - ADR-AUTO-BUNDLE#5
---

# automation/Catzc.Base.Exporter/Assert-CatzcBundle.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The build's integrity guard ([ADR-AUTO-BUNDLE#5](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle5)).
Given a build root — out/automation/built/<bundle>/Catzc/<version>/,
or an installed copy — it asserts:
  - layout: build.json, Catzc.psd1, Catzc.psm1, Import-Catzc.ps1 and the .internal loader are present, and the
    folder is named for build.json's version (a valid Catzc/<version>/ module folder);
  - no tests/ surface anywhere outside .vendor/ (vendored modules are copied verbatim, by rule);
  - types: exactly one .compiled/Catzc.Types.<hash>.dll, named for build.json typesHash. Every build ships the
    full type set: the selected modules' sources under <Module>/types/, every other module's under
    .compiled/types/<Module>/. build.json typeSources lists them all (build-relative paths); each must exist,
    no shipped source may be missing from the list, and the sources in the list must hash (Get-CombinedTypeHash,
    the one implementation) to typesHash — "the DLL was built from these sources" is proven by hash;
  - modules: the module folders are exactly build.json's modules; each has its <Module>.psd1 and merged
    <Module>.functions.ps1, the manifest's NestedModules is exactly that one file (a nested <Module>.ps1 would
    load a second module named <Module>, which Get-Module, Mock -ModuleName and InModuleScope reject), and
    every FunctionsToExport name resolves to a top-level function in the merged file (AST);
  - content: Get-CatzcContentHash over the tree (build.json excluded — it carries the hash) equals build.json
    contentHash, so nothing drifted after the build.
Collects every violation and throws once. Build-Modules runs it on its own output; Install-Catzc runs it on
the build before touching a destination.
```

## comment:2

Above `$staging = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(),...`.

```text
Stage the sources build.json records in the one layout Get-CombinedTypeHash reads (<Module>/types/<File>.cs), so the
hash comes from the one implementation rather than a second copy of its recipe.
```
