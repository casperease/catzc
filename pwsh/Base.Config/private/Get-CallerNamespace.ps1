function Get-CallerNamespace {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $systemNamespace = 'Catzc'
    # Frame 0 is this function and frame 1 the reader that asked, so the walk starts at the reader's own caller.
    foreach ($frame in @(Get-PSCallStack | Select-Object -Skip 2)) {
        $callerModule = if ($frame.InvocationInfo -and $frame.InvocationInfo.MyCommand) {
            [string] $frame.InvocationInfo.MyCommand.ModuleName
        }
        if ($callerModule) {
            $dot = $callerModule.IndexOf('.')
            if ($dot -gt 0) {
                return $callerModule.Substring(0, $dot)
            }
            return $systemNamespace
        }
    }
    $systemNamespace
}
