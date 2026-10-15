---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepConfigClassViolations.ps1.md
    kind: reference
    body_sha: f4342ccff482
    adrs: []
---

# automation/Catzc.Azure.Templates/private/Get-BicepConfigClassViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Checks one config against the template's env-class bit and returns a (possibly empty) array of
human-readable violation strings:
  - env-class bit: subscription ⇒ the config env must be a per_subscription env (nsub/psub);
                   standard ⇒ it must be a standard env.
The slot is a per-config dimension, not a template-level bit — a template may freely mix slotted
(<env>-<slot>.yml) and non-slotted (<env>.yml) configs — so there is no slot rule here.
Empty result means the config conforms.
```
