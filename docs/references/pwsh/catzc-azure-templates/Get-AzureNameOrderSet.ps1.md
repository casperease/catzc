# pwsh/Azure.Templates/Get-AzureNameOrderSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the named component orders Get-AzureResourceName can assemble names in.

### description

Each order is an ordered list of _segments_; each segment is a list of component names that fuse together (concatenated with no separator),
and segments are joined by the render separator of the type's pattern (hyphen for long/kv, nothing for storage/vm). Components: env, slot,
region, org, short_name, customer, role, type. `env` and `slot` are SEPARATE segments. Optional components (slot, customer, role) are
skipped when empty; an empty segment is dropped.

```text
standard — env then slot first, type last (the catzc default):
           <env>-<slot>-<region>-<org>-<short_name>[-<customer>][-<role>]-<type>
classic  — type first (CAF-style), slot trailing:
           <type>-<org>-<short_name>[-<customer>]-<env>-<region>[-<slot>][-<role>]
```

The active order is selected by the `ado_naming` repo-wide variant — Get-AdoNaming (default `standard`), a variants.yml setting fixed for
the importer session. Orders are pure data — add or reorder one here without touching the assembler.

### example 1

```powershell
(Get-AzureNameOrderSet).standard
```
