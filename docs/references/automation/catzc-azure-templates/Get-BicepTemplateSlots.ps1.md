# docs/references/automation/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md

`automation/Catzc.Azure.Templates/Get-BicepTemplateSlots.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single source of the slot list used by the -Slot ArgumentCompleter on every deploy/name
path. A template's slots come from its config files: `<env>.yml` is the base slot (empty
discriminator, NOT offered for completion) and `<env>-<slot>.yml` is the slot `<slot>`. This
returns the distinct non-empty discriminators, optionally filtered to one environment, so
`-Slot <TAB>` offers exactly the real special slots for the bound -Template (and -Environment).

Returns an empty array when -Template is omitted/unknown or the template has only base slots —
completers must degrade quietly, never throw.

Centralising it (like Get-BicepTemplateNames does for -Template) keeps the completer scriptblocks
one-liners and avoids the [ordered]-dict / comma-wrapped Get-BicepTemplates enumeration traps.
```

## comment:2

Section `.PARAMETER Customer` of the comment-based help.

```text
Customer filter — only the slots of this customer's configuration subfolder (omitted/empty = the
configuration-root, shared-platform slots).
```

## comment:3

Above `$wantCustomer = [string]$Customer`.

```text
slots are [ordered] dicts -> use the script-block Where-Object/ForEach-Object form (the
`Where-Object prop -EQ` shortcut does not bind ordered-dict keys). Filter by customer — the
configuration axis; empty/unbound = the configuration-root (shared-platform) slots.
```
