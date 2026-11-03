function Get-HostPlatform {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    # The running host as '<os>/<arch>' in the Go spelling, the one name the exporters target and the runner picks a binary by.
    $os = if ($IsWindows) {
        'windows'
    }
    elseif ($IsMacOS) {
        'darwin'
    }
    else {
        'linux'
    }
    $arch = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq [System.Runtime.InteropServices.Architecture]::Arm64) {
        'arm64'
    }
    else {
        'amd64'
    }
    "$os/$arch"
}
