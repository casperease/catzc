# automation/Catzc.Base.Asserts/Assert-IsGuid.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a string is a valid GUID.

### parameter ObjectGuid

The string to validate as a GUID.

### example 1

```powershell
Assert-IsGuid 'a55e0700-a000-601d-0000-000000000000'
```
