function Get-GeneratedWriterRow {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedWriterRow])]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    $rows = @(foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
            (Get-Config -Config generated -Module $owner.Module).writers | Where-Object name -CEQ $Name
        })
    Assert-True ($rows.Count -eq 1) -ErrorText "Get-GeneratedWriterRow: the writer registry declares the writer '$Name' $($rows.Count) times; a stamp needs exactly one row."
    $rows[0]
}
