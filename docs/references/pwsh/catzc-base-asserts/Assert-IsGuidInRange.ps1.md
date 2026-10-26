# pwsh/Base.Asserts/Assert-IsGuidInRange.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
