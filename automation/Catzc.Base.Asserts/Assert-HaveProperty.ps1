<#
.SYNOPSIS
    Asserts that an object has a named property, or a nested chain of properties.
.PARAMETER Object
    The object to inspect.
.PARAMETER PropertyName
    The property name that must exist on the object. Dotted paths
    (e.g. 'parent.child.etc.value') are walked level by level; the failure
    message names the deepest segment that was reached before the chain broke.
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
