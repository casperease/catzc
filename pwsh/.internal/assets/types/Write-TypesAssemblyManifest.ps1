function Write-TypesAssemblyManifest {
    # .SYNOPSIS
    #     Writes the manifest Catzc.Types.<hash>.json beside a combined types assembly, unless it is there already.
    # .DESCRIPTION
    #     The manifest is generated from the assembly's own metadata, never edited, and named by the same hash as the
    # assembly, so
    #     the two always describe the same build. It is written to a temporary file and moved into place.
    # .PARAMETER Path
    #     The assembly (Catzc.Types.<hash>.dll) to describe.
    # .OUTPUTS
    #     [string] The manifest path.
    # .EXAMPLE
    #     Write-TypesAssemblyManifest -Path $dll
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes a generated build artifact beside the assembly; the build and the importer announce the build.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The caller (Build-CombinedTypeAssembly, Import-CSharpTypes) announces the build; the analyzer rule runs where only diagnostic records may be emitted.')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $manifestPath = [System.IO.Path]::ChangeExtension($Path, 'json')
    if ([System.IO.File]::Exists($manifestPath)) {
        return $manifestPath
    }

    $hash = [System.IO.Path]::GetFileNameWithoutExtension($Path) -replace '^Catzc\.Types\.', ''
    $manifest = [ordered]@{ hash = $hash; types = @((Get-TypesAssemblyManifest -Path $Path).Types | ForEach-Object { [ordered]@{ name = $_.Name; aliases = @($_.Aliases); display = @($_.Display) } }) }
    $json = (ConvertTo-Json -InputObject $manifest -Depth 5) -replace "`r`n", "`n"
    $tmp = "$manifestPath.$PID.tmp"
    try {
        [System.IO.File]::WriteAllText($tmp, $json + "`n", [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::Move($tmp, $manifestPath)
    }
    catch {
        # A concurrent writer that won the race left an equivalent manifest; anything else is a real failure.
        if (-not [System.IO.File]::Exists($manifestPath)) {
            throw
        }
    }
    finally {
        if ([System.IO.File]::Exists($tmp)) {
            [System.IO.File]::Delete($tmp)
        }
    }
    $manifestPath
}
