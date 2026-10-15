<#
.SYNOPSIS
    The body-sha meta kind's fact: the hash of the file's body below its front matter
    ([ADR-REPO-MDMETA#3](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta3)).
.DESCRIPTION
    The hash changes exactly when the body does; front matter and line endings never move it.
.PARAMETER Document
    The parsed Markdown file.
.PARAMETER Path
    The file's repository-relative path.
.PARAMETER Kind
    The registry entry that subscribed this function.
.OUTPUTS
    [System.Collections.Specialized.OrderedDictionary] one entry per key of the kind.
#>
function Get-BodyShaMarkdownMetaFact {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.MarkdownMeta.MarkdownDocument] $Document,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.MarkdownMetaKind] $Kind
    )

    [ordered]@{ $Kind.keys[0] = $Document.BodyHash() }
}
