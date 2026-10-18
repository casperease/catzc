# automation/Catzc.Base.ModuleSystem/Get-ModuleProfile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves a named profile (or an explicit seed list) to the full set of disk-module names to copy — the
dependency closure of the seed plus the fixed infrastructure needed to load and test.

### description

A profile (configs/profiles.yml) is a seed list of module names. This expands the seed to its transitive
declared-dependency closure (Get-ModuleDependencyClosure) so the result is loadable, then appends the fixed
infrastructure modules (.internal, .compiled, .vendor) unless -NoInfrastructure. An empty seed (the `full`
profile, or an empty -Modules) resolves to every on-disk named module.

The result is the module-name set to feed Copy-Automation -ModuleNames (Copy-Automation -ModuleProfile does
this for you) or Test-InIsolation.

### parameter Name

A profile name from profiles.yml (minimal, base, azure, tooling, full, …).

### parameter Modules

An explicit seed list instead of a named profile — resolved through the same closure logic.

### parameter NoInfrastructure

Omit the fixed infrastructure modules (.internal, .compiled, .vendor); return only named modules.

### outputs

`[string[]]` The disk-module names (named + infrastructure), ordinal-sorted.

### example 1

```powershell
Get-ModuleProfile -Name azure
```

### example 2

```powershell
Get-ModuleProfile -Modules Catzc.Base.Config   # explicit, same closure logic
```
