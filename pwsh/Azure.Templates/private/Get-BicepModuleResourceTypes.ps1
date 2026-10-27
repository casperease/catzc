function Get-BicepModuleResourceTypes {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string] $Path = (Join-Path (Get-RepositoryRoot) (Get-TrackPlace -Track vendor_azure.bicep -TrackKind modules))
    )

    # A declared resource, never an `existing` reference: the module deploys it, so the landing zone allows its type.
    $declaration = [regex]::new("^\s*resource\s+\w+\s+'(?<type>[A-Za-z0-9.]+/[A-Za-z0-9./]+)@[^']+'\s+(?!existing\b)")
    $types = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($file in @(Get-ChildPath -Path $Path -Depth 1 -Filter '*.bicep' -File)) {
        foreach ($line in [System.IO.File]::ReadAllLines($file)) {
            $match = $declaration.Match($line)
            if ($match.Success) {
                [void] $types.Add($match.Groups['type'].Value)
            }
        }
    }
    [string[]] @($types)
}
