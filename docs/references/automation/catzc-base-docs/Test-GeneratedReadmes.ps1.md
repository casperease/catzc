---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Test-GeneratedReadmes.ps1.md
    kind: comment-page
    body_sha: "4169ef33e6b7"
    adrs:
      - ADR-AUTO-TEST#35
    links: []
---

# automation/Catzc.Base.Docs/Test-GeneratedReadmes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the
generated READMEs ([ADR-REPO-README](/docs/adr/repository/generated-readmes.md)). readme.yml, expanded by
Get-ReadmeMappings exactly as Build-Readme expands it, lists the folders whose README.md is generated from a docs/
source — a derived artifact, never authored in place. For each, it collects an issue when the README is:

  - not matched by a .gitignore rule (`git check-ignore --no-index` evaluates the rules alone; the default would
    consult the index and call a wrongly tracked file "not ignored", masking the next check);
  - tracked in git (remove it with `git rm --cached <path>`; the file stays on disk, ignored);
  - missing or stale: not what Build-Readme would write now (Get-ReadmeContent, compared EOL-insensitively by
    Write-FileIfChanged -DryRun) — re-run the importer, which regenerates it.

Hand-authored READMEs are the folders not in readme.yml and are out of scope. It reads the repository's files,
.gitignore, and git index, which exist only in a git work tree of the source tree (Get-ReadmeMappings).
```
