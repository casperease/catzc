# pwsh/Tooling.Claude/private/Resolve-SharedConfigPath.ps1

A private helper of Lock-SharedConfig and Unlock-SharedConfig. It turns a shared config's name into the one file an editor claim names.

## help

### synopsis

Returns the path of the one file a shared config resolves to, the file an editor claim covers.

### description

The name must be listed in `shared_configs` of `editor-claims.yml`, or the call throws. The file is found the way Get-Config finds it, so a
claim names the one file every session's next import reads; a config that resolves to no file or to more than one throws, since no one file
can be claimed, and the file must exist.

Private helper of Lock-SharedConfig and Unlock-SharedConfig; not exported.

### parameter `Name`

The shared config's name, such as `timeouts`.

### outputs

`[string]` The full path of the config file.

### example 1

```powershell
Resolve-SharedConfigPath -Name timeouts
```
