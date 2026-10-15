---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/Get-CatzcModulesRoot.ps1.md
    kind: comment-page
    body_sha: "27f4427c6410"
---

# automation/Catzc.Base.Repository/Get-CatzcModulesRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns $env:CatzcModulesRoot, the well-known anchor the importer sets to the automation/ directory holding
the running catzc modules. In the mono repo this is <RepositoryRoot>/automation; in an installed bundle it
is the bundle's own automation/, so config, type and vendor discovery follow the code wherever it is
installed instead of assuming it sits under the working RepositoryRoot.

Distinct from Get-RepositoryRoot: RepositoryRoot is the working root (where out/ goes, what repo-relative
paths and git resolve against); CatzcModulesRoot is where catzc's own code lives. The two coincide in the
mono repo and diverge only in an install. Falls back to <RepositoryRoot>/automation when the anchor is not
set — a module imported without the importer — so behaviour is unchanged when nothing set the anchor.
```
