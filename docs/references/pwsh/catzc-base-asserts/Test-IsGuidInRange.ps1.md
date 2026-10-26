# pwsh/Base.Asserts/Test-IsGuidInRange.ps1

The query form that answers whether a GUID lies inside an inclusive GUID range and defines the ordering; `Assert-IsGuidInRange` is its
throwing form.

## help

### synopsis

Tests whether a GUID lies inside an inclusive GUID range.

### description

Orders GUIDs by their 128 bits as written — the canonical lowercase hyphenated form, compared ordinally — which is how a reader sees a range
in config, whatever case or braces the inputs use. A non-GUID input, or a range whose From is after its To, is a caller error and throws.

### parameter `ObjectGuid`

The GUID to test.

### parameter `From`

The first GUID of the range (inclusive).

### parameter `To`

The last GUID of the range (inclusive).

### example 1

```powershell
Test-IsGuidInRange $budget -From $exemption.range.from -To $exemption.range.to
```
