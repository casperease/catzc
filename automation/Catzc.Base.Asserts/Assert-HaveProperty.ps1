<#
.SYNOPSIS
    Asserts that an object has a named property, or a nested chain of properties.
.PARAMETER Object
    The object to inspect.
.PARAMETER PropertyName
    The property name that must exist on the object.
    [comment:1](/docs/references/automation/catzc-base-asserts/Assert-HaveProperty.ps1.md#comment1)
.EXAMPLE
    Assert-HaveProperty $response 'StatusCode'
.EXAMPLE
    Assert-HaveProperty $config 'parent.child.etc.value'
#>
function Assert-HaveProperty {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object] $Object,

        [Parameter(Mandatory, Position = 1)]
        [string] $PropertyName
    )

    if (Test-HaveProperty $Object $PropertyName) {
        return
    }

    $current = $Object
    $traversed = @()
    foreach ($segment in $PropertyName -split '\.') {
        if ($null -eq $current -or $segment -notin $current.PSObject.Properties.Name) {
            $path = ($traversed + $segment) -join '.'
            throw "Object does not have property '$path'"
        }
        $traversed += $segment
        $current = $current.$segment
    }
}
