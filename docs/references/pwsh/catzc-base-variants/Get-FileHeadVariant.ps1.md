# pwsh/Catzc.Base.Variants/Get-FileHeadVariant.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns whether an authored code or config file carries the navigation head ('minimal' or 'none').

### description

The `file_heads.code` repo-wide variant (configs/variants.yml), fixed for the importer session. 'minimal' (VariantsConfig's
DefaultFileHeadsCode) gives every authored code or config file the navigation head, its body hash and its edges to the rules it cites, its
comment page and its test; 'none' gives none and strips one a file holds. A generated file's head is outside the variant. See
[ADR-REPO-VARIANT-FILEHEADS](../../../drs/repository/repo-variants.md#rule-adr-repo-variant-fileheads).

### outputs

`[string]` 'minimal' or 'none'.

### example 1

```powershell
Get-FileHeadVariant   # -> 'minimal'
```
