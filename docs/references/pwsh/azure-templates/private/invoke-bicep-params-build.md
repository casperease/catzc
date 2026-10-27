# pwsh/Azure.Templates/private/Invoke-BicepParamsBuild.ps1

The private function that compiles one `.bicepparam` file to its ARM parameters JSON with `bicep build-params`.

## help

### synopsis

Compiles one .bicepparam file to its ARM parameters JSON with `bicep build-params`.

### description

Build-Bicep's one call of the compiler for a slot, whether the .bicepparam was hand-written or rendered by ConvertTo-BicepParam. The
compiler's output is dropped; the written file is the proof, so a run that reports success but leaves no parameters file throws, naming both
paths. Each file written is announced with Write-Message.

### parameter `BicepPath`

The bicep binary Build-Bicep resolved once from tools.yml.

### parameter `BicepParamPath`

The .bicepparam file to compile.

### parameter `ParametersPath`

The ARM parameters JSON to write.

### example 1

```powershell
Invoke-BicepParamsBuild -BicepPath $bicep.Path -BicepParamPath $bicepParamPath -ParametersPath $paramsPath
```
