<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Test-HaveProperty.ps1
    kind: function
    module: Catzc.Base.Asserts
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether an object has a specific property, or a nested chain of properties.
.PARAMETER Object
    The object to inspect.
.PARAMETER PropertyName
    A missing or null-valued level in a dotted path returns false at once instead of throwing.
    [comment:1](/docs/references/automation/catzc-base-asserts/Test-HaveProperty.ps1.md#comment1)
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
