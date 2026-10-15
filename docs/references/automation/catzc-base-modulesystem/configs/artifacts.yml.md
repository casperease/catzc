# docs/references/automation/catzc-base-modulesystem/configs/artifacts.yml.md

`automation/Catzc.Base.ModuleSystem/configs/artifacts.yml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `ado: { enabled: false, organization: "", project: "", feed: "" }`.

```text
Publish targets for versioned, immutable module-manifest artifacts (the gold psd1 objects a CI build
promotes to a feed). NOT YET IMPLEMENTED — these keys are inert config surface: present, documented, and
loaded via Get-Config, but no publish code reads them yet (that is Phase 2: the CI publish step + the BVT
pipeline that promotes the gold artifact). See [ADR-AUTO-TEST](/docs/adr/automation/test-automation.md) (BVT) and
out/tmp/plan-psd1-gold-artifacts.md.
```
