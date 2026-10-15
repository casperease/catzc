<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FileMetaFact.ps1
    kind: fact-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Get-FileMetaFact.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#4
  config:
    synopsis: Collects the derived facts of one Markdown file from every imprint kind whose globs match it.
    description: |-
      Each kind's processor is the function the registry names, found in this module's scope; a kind with no such function fails the
      run and names the function it expected. A processor must return exactly the keys its kind declares, so a kind can never write a
      key another kind owns. The facts come back in registry order, which is the order they are written.
    parameters:
      State: What Get-MarkdownMetaState read from the file.
      Path: The file's repository-relative path.
      Config: The meta-kind registry.
    outputs: '[System.Collections.Specialized.OrderedDictionary] key to value, in registry order.'
---
#>

function Get-FileMetaFact {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.FileMetaConfig] $Config
    )

    $facts = [ordered]@{}
    foreach ($kind in $Config.Imprint()) {
        $applies = @($kind.files | Where-Object { [Catzc.Base.Globs.GlobPattern]::new($_).Matches($Path) })
        if ($applies.Count -eq 0) {
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
            $facts[$key] = $produced[$key]
        }
    }
    $facts
}
