function Get-GeneratedWriterOrder {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedWriterRow])]
    param()

    $rows = foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
        (Get-Config -Config generated -Module $owner.Module).writers
    }
    [Catzc.Base.GeneratedFiles.GeneratedFilesConfig]::RenderOrder([Catzc.Base.Variants.GeneratedWriterRow[]] @($rows))
}
