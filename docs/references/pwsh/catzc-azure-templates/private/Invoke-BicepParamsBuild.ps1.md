# pwsh/Catzc.Azure.Templates/private/Invoke-BicepParamsBuild.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Compiles one .bicepparam file to its ARM parameters JSON with `az bicep build-params`.

### description

Build-Bicep's one call of the compiler for a slot, whether the .bicepparam was hand-written or rendered by ConvertTo-BicepParam. The az
output is dropped; the written file is the proof, so a run that reports success but leaves no parameters file throws, naming both paths.
Each file written is announced with Write-Message.

### parameter `BicepParamPath`

The .bicepparam file to compile.

### parameter `ParametersPath`

The ARM parameters JSON to write.

### example 1

```powershell
Invoke-BicepParamsBuild -BicepParamPath $bicepParamPath -ParametersPath $paramsPath
```
