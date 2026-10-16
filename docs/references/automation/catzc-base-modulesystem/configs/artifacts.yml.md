---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/configs/artifacts.yml.md
    folder: docs/references/automation/catzc-base-modulesystem/configs
    name: artifacts-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e692d3570f46
---

# automation/Catzc.Base.ModuleSystem/configs/artifacts.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ado: { enabled: false, organization: "", project: "", feed: "" }`, written with `#`.

```text
Publish targets for versioned, immutable module-manifest artifacts (the gold psd1 objects a CI build
promotes to a feed). NOT YET IMPLEMENTED — these keys are inert config surface: present, documented, and
loaded via Get-Config, but no publish code reads them yet (that is Phase 2: the CI publish step + the BVT
pipeline that promotes the gold artifact). See [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md) (BVT) and
out/tmp/plan-psd1-gold-artifacts.md.
```
