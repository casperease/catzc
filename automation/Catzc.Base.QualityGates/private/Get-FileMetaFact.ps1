<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/private/Get-FileMetaFact.ps1
    folder: private
    name: get-file-meta-fact
    filetype: ps1
    kind: function
    subkind: fact
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-FileMetaFact.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#4
  config:
    synopsis: Collects the place facts and the edges of one file from every imprint kind that selects it, by the file's class and language.
    description: |-
      Each kind's processor is the function the registry names, found in this module's scope; a kind with no such function fails the
      run and names the function it expected. A processor must return exactly the keys its kind declares, so a kind can never write a
      key another kind owns. Each key goes into the part its kind names, `immutable` or `edges`, and comes back in registry order, which
      is the order it is written.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Config: The meta-kind registry.
    outputs: '[pscustomobject] @{ Immutable; Edges }, each an ordered dictionary of key to value, in registry order.'
---
#>

function Get-FileMetaFact {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaConfig] $Config
    )

    $facts = @{ immutable = [ordered]@{}; edges = [ordered]@{} }
    $language = (Get-Config -Config languages).ForPath($Path)
    $languageName = if ($language) {
        $language.name
    }
    else {
        $null
    }
    $fileClass = (Get-FileKind $Path).Class
    foreach ($kind in $Config.Imprint()) {
        if (-not $Config.Selects($kind, $fileClass, $languageName)) {
            continue
        }
        $processor = Get-Command -Name $kind.processor -CommandType Function -ErrorAction Ignore
        Assert-NotNull $processor -ErrorText "file-meta config: kind '$($kind.id)' is subscribed by '$($kind.processor)', but no such function exists."
        $produced = & $kind.processor -State $State -Path $Path -Kind $kind
        $expected = @($kind.keys)
        $actual = @($produced.Keys)
        Assert-True (($actual -join ',') -ceq ($expected -join ',')) `
            -ErrorText "file-meta config: '$($kind.processor)' returned keys [$($actual -join ', ')], but kind '$($kind.id)' declares [$($expected -join ', ')]."
        foreach ($key in $expected) {
            $facts[$kind.section][$key] = $produced[$key]
        }
    }
    [pscustomobject]@{ Immutable = $facts['immutable']; Edges = $facts['edges'] }
}
