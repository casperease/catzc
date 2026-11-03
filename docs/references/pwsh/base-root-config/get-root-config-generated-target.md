# pwsh/Base.RootConfig/Get-RootConfigGeneratedTarget.ps1

The generated-target expander that names the root config files the repository opts into, each with its generator.

## help

### synopsis

Returns one generated target for each opted-in file of the root config.

### description

Reads the rootconfig config and returns a target for each file with `optIn`. A file's generator is its own `generator`, else
Build-RootConfig, which copies it; the target takes the class of the writer row that names that generator, else the given class, and records
whether the file is committed. The given name is not used, since the generators come from the config.

### parameter `Name`

The writer row's name, which this expander does not use.

### parameter `Class`

The class a target takes when no writer row names its generator.

### example 1

```powershell
Get-RootConfigGeneratedTarget -Name Build-RootConfig -Class config
```
