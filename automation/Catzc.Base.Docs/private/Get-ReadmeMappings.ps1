<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-ReadmeMappings.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Docs
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-docs/private/Get-ReadmeMappings.ps1.md
      test: automation/Catzc.Base.Docs/tests/Get-ReadmeMappings.Tests.ps1
    adrs:
      - ADR-PWSH-PESTER#9
      - ADR-REPO-README
  config:
    synopsis: Resolves the readme config into the concrete folder -> source README copy-in list Build-Readme generates.
    description: |-
      Expands each `patterns` glob against the filesystem and merges the result with the explicit `mappings`.
      A pattern's `source` template has its `{kebab}` placeholder replaced with the matched folder's leaf name
      lowercased with dots turned to hyphens (automation/Catzc.Azure.DevOps ->
      docs/references/automation/catzc-azure-devops.md). A matched folder whose derived source file does not exist
      is skipped, so a module with no reference article yet simply gets no generated README — the importer runs
      Build-Readme on every load and must never throw when a source is missing. An explicit mapping WINS over a
      pattern that targets the same folder.

      Only a trailing `/*` glob is supported: `<prefix>/*` matches the immediate, non-dot-prefixed subdirectories
      of `<prefix>`. The globs expand over the catzc source tree, so it runs in source mode only
      (Assert-SourceTree). See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
    parameters:
      Config: 'The parsed readme config (Get-Config -Config readme): a `{ patterns; mappings }` object.'
      RepositoryRoot: Repository root the globs and source paths resolve against. Defaults to Get-RepositoryRoot.
    outputs: |-
      [object[]] One `{ folder; source }` object per generated README — explicit mappings first, then the
      pattern-derived folders in filesystem order.
---
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
