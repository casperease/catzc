# pwsh/Base.QualityGates/private/Get-TestExcludeTag.ps1

Computes the Pester ExcludeTag list for a tier range and a category. Test-Automation and Test-InIsolation share it, so the tier and category
filter cannot differ between the two.

## help

### synopsis

Computes the Pester ExcludeTag list for a tier range + category — shared by Test-Automation and Test-InIsolation so the tier/category filter
has one definition.

### description

Excludes every tier tag outside [MinLevel, MaxLevel] and, when -Category is Logic or Integrity, the OTHER category's tag. ExcludeTag values
are lowercase to match the test files' actual tags ('logic'/'integrity'); tier tags are `[Catzc.Base.Timeouts.TestTiers]::Names`
('L0'..'L4'). A mixed file's per-Context category tags filter correctly because ExcludeTag matches an item's own tag.

### parameter `MinLevel`

Lowest tier to keep (0-4). Tiers below it are excluded.

### parameter `MaxLevel`

Highest tier to keep (0-4). Tiers above it are excluded.

### parameter `Category`

Logic (exclude integrity), Integrity (exclude logic), or Both (exclude neither).

### example 1

```powershell
Get-TestExcludeTag -MinLevel 0 -MaxLevel 1 -Category Logic   # -> L2, L3, integrity
```
