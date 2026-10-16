---
catzc:
  immutable:
    with_body_sha: "39ddb629c495"
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
    folder: docs/references/automation/catzc-azure-templates/private
    name: get-bicep-config-subscription-candidates-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($token -ceq $Customer -or (Get-AzureCustomer $token).key -ceq $Customer) {`, written with `#`.

```text
Customer config: match the raw token first (the common, by-key binding), and only resolve a
non-matching token through the catalogue (the by-shortcode binding) — keeps the read lazy.
```
