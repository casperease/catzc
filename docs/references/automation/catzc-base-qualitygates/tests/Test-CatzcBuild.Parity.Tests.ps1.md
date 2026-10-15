---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.Parity.Tests.ps1.md
    kind: test-asset
    body_sha: "1b1aaab2545b"
    adrs:
      - ADR-DSGN-RUNMODE#2
---

# automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Parity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Built modules match their source folders' -Tag 'L2', 'integrity',...`.

```text
Parity ([ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)): every built module is the same
module as its source folder — its exported command set equals the folder's public function files, and its private
function set equals the folder's private/ files. Test-BuildArtifact reads the source side from the files and the
build side from the modules as a build-mode session actually loads them. source-only: it compares the source tree
with a fresh build of it, entered in its own child pwsh, so the answer does not depend on the mode of the session
running it. greedy: one full build plus one importer-loading child pwsh.
```
