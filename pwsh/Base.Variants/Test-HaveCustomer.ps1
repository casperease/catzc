function Test-HaveCustomer {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name
    )

    Test-HaveCustomers -Name $Name
}
