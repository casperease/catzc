---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-BaseModule.ps1.md
    kind: comment-page
    body_sha: "512f67e2a1c8"
    adrs: []
    links: []
---

# automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The typed view of the module system. Two facets, six kinds:

  on-disk (folders under the loaded code root, Get-CatzcModulesRoot, returned as DiskModule with the
  folder's source-layout path, automation/<Name>, and the named packages it owns from configs/files.yml):
    'named'    a non-dot module folder (Catzc.*)
    'hidden'   a dot-prefixed folder (.internal, .vendor, .compiled, .scriptanalyzer)

  in-session (every module loaded in the session, mapped by HOW IT CAME INTO PLAY — its ModuleBase
  location — returned as SessionModule with ModuleBase + Version):
    'imported' our automation module   — ModuleBase under the code root (not .vendor)
    'vendored' our vendored third-party — ModuleBase under the code root's .vendor/
    'builtin'  shipped with PowerShell  — ModuleBase under $PSHOME
    'residue'  genuinely foreign        — anything else (user profile, PowerShell Gallery, manual import)

Both facets classify against the code root, not <RepositoryRoot>/automation, so the answer is correct in
both run modes
([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)): in build mode the loaded modules live in the built package.

Default returns the on-disk kinds (named + hidden). Copy-Automation and the module completers act on those;
the session kinds map what is loaded and where it came from (diagnostics, collision reporting).
```
