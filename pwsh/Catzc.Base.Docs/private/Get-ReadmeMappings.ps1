<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-ReadmeMappings.ps1
    folder: private
    name: get-readme-mappings
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-ReadmeMappings.Tests.ps1
    docs: "[Get-ReadmeMappings.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-ReadmeMappings.ps1.md)"
    cites:
      - ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS
      - ADR-REPO-README
---
#>

function Get-ReadmeMappings {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Config,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # The globs expand over the source tree's folders (pwsh/* and the like).
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
            throw "Unsupported README glob '$($pattern.glob)'. Only a trailing '/*' is supported (e.g. '<folder>/*')."
        }

        $prefixPath = Join-Path $RepositoryRoot $prefix
        if (-not (Test-Path $prefixPath -PathType Container)) {
            continue
        }

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
