<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Get-GlossarySources.ps1.md"
  header: "generated"
---
#>

function Get-GlossarySources {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    Assert-SourceTree

    $owners = @(Get-Config -Config glossary -ListOwners)
    if ($owners.Count -eq 0) {
        return
    }

    $paths = [string[]] @(foreach ($owner in $owners) {
            ConvertTo-RepoRelativePath $owner.Path
        })
    $tracked = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($path in @(Get-GitTrackedPath $paths)) {
        [void] $tracked.Add($path)
    }

    for ($i = 0; $i -lt $owners.Count; $i++) {
        # A source split into a folder of parts is tracked when every part is.
        $isTracked = if ([System.IO.Directory]::Exists($owners[$i].Path)) {
            $parts = @([System.IO.Directory]::GetFiles($owners[$i].Path, '*.yml'))
            $parts.Count -gt 0 -and @($parts | Where-Object { -not $tracked.Contains("$($paths[$i])/$([System.IO.Path]::GetFileName($_))") }).Count -eq 0
        }
        else {
            $tracked.Contains($paths[$i])
        }
        [pscustomobject]@{
            Owner   = $owners[$i].Module
            Path    = $paths[$i]
            Config  = Get-Config -Config glossary -Module $owners[$i].Module
            Tracked = $isTracked
        }
    }
}
