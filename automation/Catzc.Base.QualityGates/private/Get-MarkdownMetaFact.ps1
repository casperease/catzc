<#
.SYNOPSIS
    Collects the derived facts of one Markdown file from every imprint kind whose globs match it
    ([ADR-REPO-FILEMETA#4](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta4)).
.DESCRIPTION
    Each kind's processor is the function the registry names, found in this module's scope; a kind with no such function fails the
    run and names the function it expected. A processor must return exactly the keys its kind declares, so a kind can never write a
    key another kind owns. The facts come back in registry order, which is the order they are written.
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Config
    The meta-kind registry.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] key to value, in registry order.
#>
function Get-MarkdownMetaFact {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.MarkdownMetaConfig] $Config
    )

    $facts = [ordered]@{}
    foreach ($kind in $Config.Imprint()) {
        $applies = @($kind.files | Where-Object { [Catzc.Base.Globs.GlobPattern]::new($_).Matches($Path) })
        if ($applies.Count -eq 0) {
            continue
        }
        $processor = Get-Command -Name $kind.processor -CommandType Function -ErrorAction Ignore
        Assert-NotNull $processor -ErrorText "markdown-meta config: kind '$($kind.id)' is subscribed by '$($kind.processor)', but no such function exists."
        $produced = & $kind.processor -State $State -Path $Path -Kind $kind
        $expected = @($kind.keys)
        $actual = @($produced.Keys)
        Assert-True (($actual -join ',') -ceq ($expected -join ',')) `
            -ErrorText "markdown-meta config: '$($kind.processor)' returned keys [$($actual -join ', ')], but kind '$($kind.id)' declares [$($expected -join ', ')]."
        foreach ($key in $expected) {
            $facts[$key] = $produced[$key]
        }
    }
    $facts
}
