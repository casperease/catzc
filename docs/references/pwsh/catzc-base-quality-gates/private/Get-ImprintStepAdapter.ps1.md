# pwsh/Base.QualityGates/private/Get-ImprintStepAdapter.ps1

The one map from an imprint step of `languages.yml` to the functions whose code decides its verdict. The cache stamp hashes their code, so a
changed step re-checks every file it judged.

## help

### synopsis

Names the functions an imprint step runs, Invoke-ImprintStep first.

### description

The one map from a languages.yml imprint step to the PowerShell functions whose code decides its verdict: Get-FormatEngineStamp hashes their
code, with the types assembly's build identity for the step's C# engines, into the step's cache stamp, so a changed step re-checks every
file it judged. Throws for a step no adapter runs.

### parameter `Step`

The imprint step, one of the steps languages.yml declares.

### outputs

`[string[]]` The function names, Invoke-ImprintStep first.
