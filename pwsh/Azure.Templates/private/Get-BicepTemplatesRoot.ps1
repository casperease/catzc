function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) (Get-TrackPlace -Track vendor_azure.bicep -TrackKind templates)
}
