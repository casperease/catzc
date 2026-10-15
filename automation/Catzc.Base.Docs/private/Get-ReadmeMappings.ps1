<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-ReadmeMappings.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-PWSH-PESTER#9
      - ADR-REPO-README
---
#>

<#
.SYNOPSIS
    Resolves the readme config into the concrete folder -> source README copy-in list Build-Readme generates.
.DESCRIPTION
    A folder with no source file is skipped, so the importer's Build-Readme never throws on a missing article.
.PARAMETER Config
    The parsed readme config (Get-Config -Config readme): a `{ patterns; mappings }` object.
.PARAMETER RepositoryRoot
    Repository root the globs and source paths resolve against. Defaults to Get-RepositoryRoot.
.OUTPUTS
    [object[]] One `{ folder; source }` object per generated README — explicit mappings first, then the
    pattern-derived folders in filesystem order.
#>
function Get-ReadmeMappings {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Config,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # The globs expand over the source tree's folders (automation/* and the like).
    Assert-SourceTree

    # Explicit mappings first — they win over any pattern that also matches their folder.
    $byFolder = [ordered]@{}
    foreach ($mapping in @($Config.mappings)) {
        $byFolder[$mapping.folder] = [pscustomobject]@{ folder = $mapping.folder; source = $mapping.source }
    }

    foreach ($pattern in @($Config.patterns)) {
        # Only a trailing '/*' glob is supported: <prefix>/* = immediate non-dot subdirectories of <prefix>.
        if ($pattern.glob -match '^(?<prefix>.+)/\*$') {
            $prefix = $Matches['prefix']
        }
        else {
            throw "Unsupported README glob '$($pattern.glob)'. Only a trailing '/*' is supported (e.g. 'automation/*')."
        }

        $prefixPath = Join-Path $RepositoryRoot $prefix
        if (-not (Test-Path $prefixPath -PathType Container)) {
            continue
        }

        # Sorted .NET enumeration, since Get-ChildItem carries about 20ms of provider overhead per call.
        # [comment:2](/docs/references/automation/catzc-base-docs/private/Get-ReadmeMappings.ps1.md#comment2)
        foreach ($dir in ([System.IO.Directory]::EnumerateDirectories($prefixPath) | Sort-Object)) {
            $leaf = [System.IO.Path]::GetFileName($dir)
            if ($leaf.StartsWith('.')) {
                continue
            }

            $folder = "$prefix/$leaf"
            if ($byFolder.Contains($folder)) {
                continue   # an explicit mapping already owns this folder
            }

            $kebab = $leaf.ToLowerInvariant().Replace('.', '-')
            $source = $pattern.source.Replace('{kebab}', $kebab)
            $sourcePath = Join-Path $RepositoryRoot $source
            if (-not (Test-Path $sourcePath -PathType Leaf)) {
                continue   # no authored source yet — skip so the importer's Build-Readme never throws
            }

            $byFolder[$folder] = [pscustomobject]@{ folder = $folder; source = $source }
        }
    }

    @($byFolder.Values)
}
