function Get-PermanentEnvironmentVariable {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [ValidateSet('User', 'Machine')]
        [string] $Scope = 'User'
    )

    [System.Environment]::GetEnvironmentVariable($Name, $Scope)
}
