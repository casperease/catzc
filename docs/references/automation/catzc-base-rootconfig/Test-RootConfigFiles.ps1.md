---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/Test-RootConfigFiles.ps1.md
    kind: comment-page
    body_sha: a734e0175f84
    adrs:
      - ADR-AUTO-TEST#35
    links: []
---

# automation/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
opted-in entries of rootconfig.yml ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)), resolved
exactly as Build-RootConfig resolves them (Get-RootConfigTargets). A wildcard entry (e.g. go/tests/*/go.mod) is
checked per file its generator renders (Get-RootConfigRenderedFile). Per file, the entry's `committed` decides
git membership, and the registry, .gitignore, and git's tracked set must agree. It collects an issue for:

  - a committed:false target no .gitignore rule ignores, or that git tracks (a derived artifact; remove it with
    `git rm --cached <path>`);
  - a committed:true target git does not track (it is needed before the importer runs), or that an ignore rule
    matches;
  - a copyAsLink target that is not an effective link from this OS — a symbolic link resolving to its source, or
    a hard link whose bytes are CR-insensitively identical to it;
  - any other target that is a link — a copy or generator target must be a real, independent file (a flipped-back
    entry never converted would read through the link and look current).

Ignore rules are evaluated with `git check-ignore --no-index`, the rules alone: the default consults the index and
would call a wrongly tracked file "not ignored", masking the tracking check. Re-running the importer
(Build-RootConfig) repairs the link issues. It drives the git CLI, so it needs a git work tree.
```
