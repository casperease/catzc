# automation/Catzc.Base.QualityGates/private/Format-TierRange.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Formats a tier range the way a test run names it: 'L2' for one tier, 'L0-L2' for a range.

### parameter `MinLevel`

The lowest tier.

### parameter `MaxLevel`

The highest tier.

### outputs

`[string]`

### example 1

```powershell
Format-TierRange -MinLevel 0 -MaxLevel 2
```
