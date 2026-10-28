function Enable-GeneratedGuardHook {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $hook = Get-GeneratedGuardHook -RepositoryRoot $RepositoryRoot
    $current = $null
    if ([System.IO.File]::Exists($hook.Path)) {
        $current = [System.IO.File]::ReadAllText($hook.Path)
        if (-not $current.Contains($hook.Marker)) {
            throw "Enable-GeneratedGuardHook: '$($hook.Path)' is a pre-commit hook catzc did not write; move it aside first."
        }
        if ($current -ceq $hook.Shim) {
            return
        }
    }

    if ($PSCmdlet.ShouldProcess($hook.Path, 'Write the generated-files guard pre-commit hook')) {
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($hook.Path)) | Out-Null
        [System.IO.File]::WriteAllText($hook.Path, $hook.Shim, [System.Text.UTF8Encoding]::new($false))
        if (-not $IsWindows) {
            [System.IO.File]::SetUnixFileMode($hook.Path, [System.IO.UnixFileMode]'UserRead, UserWrite, UserExecute, GroupRead, GroupExecute, OtherRead, OtherExecute')
        }
        $hook.Path
    }
}
