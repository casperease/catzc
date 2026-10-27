function Get-ArmPropertyValue {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[object]])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Resource,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $nodes = [System.Collections.Generic.List[object]]::new()
    $nodes.Add($Resource)
    foreach ($segment in $Path -split '\.') {
        $many = $segment.EndsWith('[*]')
        $key = if ($many) {
            $segment.Substring(0, $segment.Length - 3)
        }
        else {
            $segment
        }
        $next = [System.Collections.Generic.List[object]]::new()
        foreach ($node in $nodes) {
            if ($node -isnot [System.Collections.IDictionary]) {
                continue
            }
            if ($node.Contains($key)) {
                $value = $node[$key]
                if ($many -and $value -is [System.Collections.IList]) {
                    foreach ($item in $value) {
                        $next.Add($item)
                    }
                }
                else {
                    $next.Add($value)
                }
            }
            elseif ($many -and $node.Contains('copy')) {
                foreach ($loop in @($node['copy'])) {
                    if ($loop -is [System.Collections.IDictionary] -and $loop['name'] -ceq $key) {
                        $next.Add($loop['input'])
                    }
                }
            }
        }
        $nodes = $next
    }
    , $nodes
}
