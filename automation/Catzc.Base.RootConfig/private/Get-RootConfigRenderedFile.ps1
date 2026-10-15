<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
    kind: automation-function
    module: Catzc.Base.RootConfig
    visibility: private
    relatives:
      test: automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
    adrs:
      - ADR-REPO-ROOTCFG
  config:
    synopsis: Renders a generator entry of the root-config registry into one { Target; Content } record per file.
    description: |-
      Calls the entry's generator through the dispatch (Invoke-RootConfigGenerator, passing the entry's target) and
      normalises its output to records, so Build-RootConfig writes every generated file the same way and
      Test-RootConfigFiles expands a wildcard entry into its files:

        - a single-file generator returns one string: the content of the entry's one target;
        - a multi-file generator returns { Target; Content } records (e.g. Catzc.Base.Languages.GoWorkspaceFile),
          each for one repository-relative path that must match the entry's target (case-sensitive wildcard
          match; a literal target matches only itself).

      A wildcard target (go/tests/*/go.mod) needs records and may render none (no folder yet); a literal target
      must render exactly one file. Any other shape throws, naming the entry and the generator. See
      [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
    parameters:
      Entry: An opted-in generator entry of rootconfig.yml (a RootConfigFile, or any object with target and generator).
    outputs: '[pscustomobject] One { Target; Content } record per rendered file, in the generator''s order.'
---
#>

function Get-RootConfigRenderedFile {
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        $Entry
    )

    $pattern = [string] $Entry.target
    $isPattern = [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($pattern)
    $rendered = @(Invoke-RootConfigGenerator -Name $Entry.generator -Target $pattern)

    if ($rendered.Count -eq 1 -and $rendered[0] -is [string]) {
        if ($isPattern) {
            throw "Root-config entry '$pattern': generator $($Entry.generator) returned one string, but a wildcard target needs one { Target; Content } record per file."
        }
        return [pscustomobject]@{ Target = $pattern; Content = $rendered[0] }
    }

    $files = foreach ($record in $rendered) {
        if ($record -is [string] -or -not $record.PSObject.Properties['Target'] -or -not $record.PSObject.Properties['Content']) {
            throw "Root-config entry '$pattern': generator $($Entry.generator) must return one string or { Target; Content } records."
        }
        $recordTarget = [string] $record.Target
        if ($recordTarget -cnotlike $pattern) {
            throw "Root-config entry '$pattern': generator $($Entry.generator) rendered '$recordTarget', which does not match the entry's target."
        }
        [pscustomobject]@{ Target = $recordTarget; Content = [string] $record.Content }
    }
    $files = @($files)

    if (-not $isPattern -and $files.Count -ne 1) {
        throw "Root-config entry '$pattern': generator $($Entry.generator) rendered $($files.Count) files for a literal target; it must render exactly one."
    }
    $files
}
