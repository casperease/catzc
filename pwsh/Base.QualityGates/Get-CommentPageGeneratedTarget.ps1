function Get-CommentPageGeneratedTarget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Every expander takes the writer row''s name and class; a comment page is authored, so this one answers no target.')]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Class
    )

    # A comment page is authored
    # ([ADR-REPO-COMMENTS-PAGEISAUTHORED](/docs/drs/repository/comments-in-docs.md#rule-adr-repo-comments-pageisauthored)), so the writer that moves comments onto it leaves no generated target.
}
