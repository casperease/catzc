<#
---
catzc:
  immutable:
    with_body_sha: b781e8567caf
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-MarkerBlastRadius.Tests.ps1
    docs: "[Get-MarkerBlastRadius.ps1.md](docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md)"
    cites:
      - ADR-REPO-PROTGLOB
      - FDR-CD-GLOBS-NAMEDGLOBSETS
---
#>

function Get-MarkerBlastRadius {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Files')]
        [string[]] $ChangedFile,

        [Parameter(Mandatory, ParameterSetName = 'Ref')]
        [string] $Ref
    )

    if ($PSCmdlet.ParameterSetName -eq 'Ref') {
        $diff = Invoke-Executable "git diff --name-only `"$Ref`"" -PassThru -Silent
        $ChangedFile = @($diff.Output -split "`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    }
    $files = @($ChangedFile | ForEach-Object { $_.Trim().Replace('\', '/') })
    if ($files.Count -eq 0) {
        return
    }

    foreach ($set in @(Get-GlobSet) + @(Get-ModuleGlobSet)) {
        foreach ($file in $files) {
            if ($set.Matches($file)) {
                [pscustomobject]@{
                    Name          = $set.Name
                    Layer         = $set.Layer
                    Pipeline      = $set.Pipeline
                    VerifyModules = @($set.VerifyModules)
                    VerifyLevel   = $set.VerifyLevel
                }
                break
            }
        }
    }
}
