function Get-CommentPage {
    [CmdletBinding(DefaultParameterSetName = 'Source')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Source')]
        [AllowEmptyString()]
        [string] $Path,

        [Parameter(Mandatory, ParameterSetName = 'Page')]
        [string] $Page,

        [Parameter(Mandatory, ParameterSetName = 'Page')]
        [AllowEmptyCollection()]
        [string[]] $TrackedPath,

        [Parameter(Mandatory)]
        [Catzc.Base.CodeMeta.CommentPagesConfig] $Config
    )

    if ($PSCmdlet.ParameterSetName -eq 'Source') {
        $found = $Config.PageFor($Path)
        if ($found) {
            $found
        }
        return
    }

    # A page back to its sources: the tracked files map forward once and the result is inverted, since the normal form reads back to no
    # file name.
    $index = $Config.PageIndex([string[]] $TrackedPath)
    $key = $Page.Replace('\', '/')
    if ($index.ContainsKey($key)) {
        $index[$key]
    }
}
