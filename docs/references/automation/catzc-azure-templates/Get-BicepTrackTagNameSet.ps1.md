---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepTrackTagNameSet.ps1.md
    kind: comment-page
    body_sha: "4cd53c0329de"
    adrs: []
---

# automation/Catzc.Azure.Templates/Get-BicepTrackTagNameSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
For ResourceGroup-target templates the tags live on the RG and have generic names
(`Deployed_From_Commit`, etc.) — every template that deploys into that RG writes the
same three tags.

For Subscription-target templates the tags live on the subscription itself, so they
are prefixed with the template name to avoid collisions across templates.

Returned shape:
  { commit, build_id, branch }
```
