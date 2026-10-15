<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-FileMetaFact.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-REPO-FILEMETA#4
---
#>

<#
.SYNOPSIS
    Collects the derived facts of one Markdown file from every imprint kind whose globs match it.
.DESCRIPTION
    A processor must return exactly its kind's keys, so a kind can never write a key another kind owns.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-FileMetaFact.ps1.md#comment1)
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Config
    The meta-kind registry.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] key to value, in registry order.
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
