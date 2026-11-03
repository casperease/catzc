# pwsh/Base.Execution/Get-HostPlatform.ps1

The one spelling of the running host's platform that the exporters target and the runner picks a binary by.

## help

### synopsis

Returns the running host as `<os>/<arch>` in the Go spelling.

### description

Answers `windows`, `darwin` or `linux` for the operating system, and `arm64` for an Arm64 host or `amd64` for any other, joined with a
slash. The exporters build for this name and the language module runner chooses the binary whose folder carries it.

### outputs

`[string]` The platform, such as `windows/amd64`.

### example 1

```powershell
Get-HostPlatform
```
