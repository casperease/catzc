<#
.SYNOPSIS
    The document-kind meta kind's fact: the class of the file, from the path globs the kind's settings declare
    ([ADR-REPO-MDMETA#3](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta3)).
.DESCRIPTION
    The first class whose globs match the path wins; a file no class matches is `other`. The classes are data in the
    registry (`settings.classes`), never a list in this function ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
.PARAMETER State
    What Get-MarkdownMetaState read from the file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
function Get-DocumentKindMarkdownMetaFact {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every meta-kind processor is called with the same State, Path and Kind; this kind classifies by path alone')]
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $State,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.MarkdownMetaKind] $Kind
    )

    $class = 'other'
    $classes = if ($Kind.settings.ContainsKey('classes')) {
        @($Kind.settings['classes'])
    }
    else {
        @()
    }
    foreach ($candidate in $classes) {
        Assert-True ($candidate -is [System.Collections.IDictionary] -and $candidate.Contains('class') -and $candidate.Contains('files')) `
            -ErrorText "markdown-meta config: kind '$($Kind.id)' settings.classes entries need 'class' and 'files'."
        $matched = @($candidate['files'] | Where-Object { [Catzc.Base.Globs.GlobPattern]::new($_).Matches($Path) })
        if ($matched.Count -gt 0) {
            $class = "$($candidate['class'])"
            break
        }
    }
    [ordered]@{ $Kind.keys[0] = $class }
}
