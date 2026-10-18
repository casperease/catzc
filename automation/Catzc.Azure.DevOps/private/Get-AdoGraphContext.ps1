function Get-AdoGraphContext {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Project,

        [Parameter(Mandatory)]
        [string] $Organization
    )

    $Organization = $Organization.TrimEnd('/')
    $graphBase = $Organization -replace '^https://dev\.azure\.com/', 'https://vssps.dev.azure.com/'
    Assert-True ($graphBase -ne $Organization) -ErrorText "Organization '$Organization' is not a https://dev.azure.com/<org> URL, so its Graph service cannot be named."

    $projectRecord = Invoke-AdoRestMethod -Uri "$Organization/_apis/projects/$([uri]::EscapeDataString($Project))?api-version=7.1" -UnwrapValue $false
    Assert-NotNull $projectRecord -ErrorText "Project '$Project' does not exist in $Organization."
    $scopeDescriptor = Invoke-AdoRestMethod -Uri "$graphBase/_apis/graph/descriptors/$($projectRecord.id)?api-version=7.1-preview.1"
    Assert-NotNullOrWhitespace "$scopeDescriptor" -ErrorText "Project '$Project' has no Graph scope descriptor in $Organization."

    [pscustomobject]@{
        Organization    = $Organization
        Project         = $Project
        ApiBase         = "$Organization/$Project/_apis"
        GraphBase       = "$graphBase/_apis/graph"
        ScopeDescriptor = "$scopeDescriptor"
    }
}
