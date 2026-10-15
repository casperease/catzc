---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md
    kind: comment-page
    body_sha: de1e0ed30a18
    adrs:
      - ADR-AUTO-TEST#26
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The output-side twin of Get-BicepTemplatesRoot: templates' output_folder descriptors resolve to
<output root>/template/<name>, and this function owns the root — <repository>/out by default. It exists
as a seam ([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)): build
tests mock it to a folder of their own so no two test files ever write
the same build folder (a fixed out/ path two files both write is the serial-tag race,
[ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26) —
mocking the seam removes the sharing instead). Keep any mocked root under the repository when the test
also asserts the repo-relative artifact contract (Get-BicepDeploymentContext relativizes against the
repository root).
```
