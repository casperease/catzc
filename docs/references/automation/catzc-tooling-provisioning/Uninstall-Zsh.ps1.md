---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-Zsh.ps1.md
    kind: comment-page
    body_sha: "495dd4691c98"
    adrs:
      - ADR-AUTO-IDEM#2
      - ADR-AUTO-REMOVE#2
      - ADR-AUTO-REMOVE#6
---

# automation/Catzc.Tooling.Provisioning/Uninstall-Zsh.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Windows: reads the manifest Install-Zsh wrote inside the Git for Windows tree (the zsh entry's windows_install_dir,
which Get-ScriptInstallDir resolves) and deletes exactly the files it lists, then the folders it lists once they
are empty, then the manifest. A file Git's tree had before Install-Zsh ran is never in the manifest, so it stays
([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)). No admin required.

Linux: removes the package the entry's apt_package names through Uninstall-Tool (apt-get), the manager Install-Zsh
installs it through ([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)).
A zsh that apt does not own stops the uninstall rather than being removed; the apt step needs root
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)).

macOS: zsh is the system's /bin/zsh, and Install-Zsh installed nothing, so there is nothing to uninstall.

Idempotent ([ADR-AUTO-IDEM#2](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2)): without a
manifest (Windows) or without zsh (Linux) it reports that there is nothing to do, and a listed file already gone is
skipped.
```

## comment:2

Above `$directories = [System.Collections.Generic.List[string]]::new([string[]]...`.

```text
Children before parents: a child sorts after its parent, so the reverse ordinal order removes the deepest first. A
folder that still holds anything (a file another tool put there) stays.
```
