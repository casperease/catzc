function Uninstall-Poetry {
    [CmdletBinding()]
    param()

    Uninstall-UvTool -Tool 'poetry'
}
