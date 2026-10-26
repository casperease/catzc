# pwsh/Azure.Templates/Get-BicepTemplateSlots.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns a template's configured (non-base) slot discriminators as a flat string array.

### description

The single source of the slot list used by the -Slot ArgumentCompleter on every deploy/name path. A template's slots come from its config
files: `<env>.yml` is the base slot (empty discriminator, NOT offered for completion) and `<env>-<slot>.yml` is the slot `<slot>`. This
returns the distinct non-empty discriminators, optionally filtered to one environment, so `-Slot <TAB>` offers exactly the real special
slots for the bound -Template (and -Environment).

Returns an empty array when -Template is omitted/unknown or the template has only base slots — completers must degrade quietly, never throw.

Centralising it (like Get-BicepTemplateNames does for -Template) keeps the completer scriptblocks one-liners and avoids the `[ordered]-dict`
/ comma-wrapped Get-BicepTemplates enumeration traps.

### parameter `Template`

Template name (folder under infrastructure/templates/).

### parameter `Environment`

Optional filter — return only slots configured for this environment name.

### parameter `Customer`

Customer filter — only the slots of this customer's configuration subfolder (omitted/empty = the configuration-root, shared-platform slots).

### example 1

```powershell
Get-BicepTemplateSlots sample-indexed            # -> 001, 002
```

### example 2

```powershell
Get-BicepTemplateSlots sample-indexed dev        # -> 001, 002 (only env 'dev')
```

## comment:1

Above `$wantCustomer = [string]$Customer`, written with `#`.

```text
slots are [ordered] dicts -> use the script-block Where-Object/ForEach-Object form (the
`Where-Object prop -EQ` shortcut does not bind ordered-dict keys). Filter by customer — the
configuration axis; empty/unbound = the configuration-root (shared-platform) slots.
```
