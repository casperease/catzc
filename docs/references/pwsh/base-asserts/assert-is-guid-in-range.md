# pwsh/Base.Asserts/Assert-IsGuidInRange.ps1

The throwing form of `Test-IsGuidInRange`: it throws when a GUID lies outside an inclusive range.

## help

### synopsis

Asserts that a GUID lies inside an inclusive GUID range.

### description

The throwing form of Test-IsGuidInRange, which defines the ordering.

### parameter `ObjectGuid`

The GUID to check.

### parameter `From`

The first GUID of the range (inclusive).

### parameter `To`

The last GUID of the range (inclusive).

### example 1

```powershell
Assert-IsGuidInRange $budget -From $exemption.range.from -To $exemption.range.to
```
