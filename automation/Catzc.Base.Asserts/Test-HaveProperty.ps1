<#
.SYNOPSIS
    Tests whether an object has a specific property, or a nested chain of properties.
.PARAMETER Object
    The object to inspect.
.PARAMETER PropertyName
    The property name to look for. Dotted paths (e.g. 'parent.child.value')
    walk each level in turn; a missing or null-valued intermediate short-circuits to $false
    rather than throwing.
.EXAMPLE
    Test-HaveProperty $object 'Name'
.EXAMPLE
    Test-HaveProperty $config 'parent.child.etc.value'
#>
function Test-HaveProperty {
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object] $Object,

        [Parameter(Mandatory, Position = 1)]
        [string] $PropertyName
    )

    $current = $Object
    foreach ($segment in $PropertyName -split '\.') {
        if ($null -eq $current -or $segment -notin $current.PSObject.Properties.Name) {
            return $false
        }
        $current = $current.$segment
    }

    $true
}
