---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/configs/profiles.yml.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "2bce25a526e7"
---

# automation/Catzc.Base.ModuleSystem/configs/profiles.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `profiles:`, written with `#`.

```text
profiles.yml — named module sets for Copy-Automation -Profile and Test-InIsolation (Catzc.Base.ModuleSystem).

Each profile is a SEED list of module names. Get-ModuleProfile expands a seed to its declared-dependency
closure (dependencies.yml) and adds the fixed infrastructure (.internal, .compiled, .vendor) needed to load
and test — so a profile pulls in everything it needs. An EMPTY seed means "everything" (the full repo).

Loaded via Get-Config -Config profiles; mapped and validated by the ProfilesConfig type (snake_case profile
names; each profile a list of module names, possibly empty).
```
