---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/Get-AdoNaming.ps1.md
    kind: comment-page
    body_sha: "6874c9804b5a"
    adrs: []
    links: []
---

# automation/Catzc.Base.Variants/Get-AdoNaming.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The `ado_naming` repo-wide variant (configs/variants.yml), fixed for the importer session. It is the
order key Get-BicepResourceName passes to Get-AzureResourceName (a key of Get-AzureNameOrderSet).
Defaults to 'standard' when the variant is unset.

*** Changing this value re-spells EVERY resource name. Resource names are typed out in each template's
configuration/[<customer>/]<slot>.yml, so flipping the order means re-editing all of them —
build-time validation flags each that no longer matches. Deliberately not a flip-the-switch option. ***
```
