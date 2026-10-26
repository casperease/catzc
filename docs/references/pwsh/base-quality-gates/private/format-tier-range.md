# pwsh/Base.QualityGates/private/Format-TierRange.ps1

Formats a tier range the way a test run names it: `L2` for one tier, `L0-L2` for a range.

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
