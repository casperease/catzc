function Set-GeneratedFileHead {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Writer
    )

    $relative = ConvertTo-RepoRelativePath (Resolve-RepoPath $Path)
    $full = Resolve-RepoPath $relative
    Assert-PathExist $full
    # Format-GeneratedFileHead finds the carrier and the writer row, so a file stamped here gets the head its writer writes.
    $arguments = @{ Path = $relative; Writer = $Writer }

    # A png is stamped as bytes; any other file is text, which keeps its own line ends.
    $before = [System.IO.File]::ReadAllBytes($full)
    if ([Catzc.Base.Languages.PngTextCarrier]::IsPng($before)) {
        $after = Format-GeneratedFileHead -Bytes $before @arguments
        if (-not [System.Linq.Enumerable]::SequenceEqual($before, $after) -and $PSCmdlet.ShouldProcess($relative, 'stamp the generated-file head')) {
            [System.IO.File]::WriteAllBytes($full, $after)
        }
        return
    }
    $before = [System.IO.File]::ReadAllText($full)
    $after = Format-GeneratedFileHead -Text $before @arguments
    if ($after -cne $before -and $PSCmdlet.ShouldProcess($relative, 'stamp the generated-file head')) {
        [System.IO.File]::WriteAllText($full, $after, [System.Text.UTF8Encoding]::new($false))
    }
}
