# pwsh/Base.Docs/Get-ReadmeGeneratedTarget.ps1

The generated-target rows for the README files the readme config places, so the variant machinery knows which README files are generated.

## help

### synopsis

Returns one generated target for each README file the readme config places.

### description

Reads the readme config and returns a generated target for `<glob>/README.md` of every pattern and for `<folder>/README.md` of every
mapping. Each target carries the given name and class, so a caller registers all of the README files under one generated artifact.

### parameter `Name`

The name every returned target carries.

### parameter `Class`

The class every returned target carries.

### example 1

```powershell
Get-ReadmeGeneratedTarget -Name readme -Class docs
```
