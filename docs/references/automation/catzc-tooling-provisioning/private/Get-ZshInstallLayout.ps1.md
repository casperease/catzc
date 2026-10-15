---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/private/Get-ZshInstallLayout.ps1.md
    kind: comment-page
    body_sha: bf31d57985f7
    adrs:
      - ADR-AUTO-ENTERP#4
---

# automation/Catzc.Tooling.Provisioning/private/Get-ZshInstallLayout.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
zsh on Windows is the MSYS2 zsh package installed into the Git Bash tree that Install-Git provides, so it runs on
Git's own MSYS2 runtime (usr\bin\msys-2.0.dll) with no admin rights
([ADR-AUTO-ENTERP#4](/docs/adr/automation/effective-in-enterprises.md#rule-adr-auto-enterp4)). That tree is declared
once, by the zsh entry's windows_install_dir in tools.yml, and resolved by Get-ScriptInstallDir. The manifest lives
inside that tree, so a tree Install-Git replaces takes the manifest with it. Install-Zsh and Uninstall-Zsh both read
the layout here, so they agree on every path.
```
