function Get-TypeSourceRecord {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        [object[]]$File,

        [Parameter(Mandatory)]
        [object]$ModuleNamespace
    )

    # Validate each source and derive its FQN (<module>.<filename>). These two poka-yokes are the loader's job,
    # deliberately NOT in the shared enumerator (the janitor must never throw on a source that is wrong): a
    # dotted filename (the old fully-qualified style) is rejected, and a file whose declared file-scoped namespace
    # does not match its module folder (or is missing/block-scoped) is rejected — the same invariant
    # Test-Formatting enforces, checked here at load; Format-Types repairs all of them. The source list is already
    # ordinally sorted.
    [object[]]@(foreach ($entry in $File) {
            # The namespace a type declares is its module's full name, resolved from the folder
            # ([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
            $folderName = $entry.Module
            $moduleName = Resolve-ModuleName -Folder $folderName -Namespace $ModuleNamespace
            $base = $entry.Base
            if ($base.Contains('.')) {
                throw "C# type file 'types/$base.cs' in module '$moduleName' must be named for the bare type only (e.g. 'CliResult.cs'); the namespace is derived from the module. Remove the dotted prefix."
            }
            $content = [System.IO.File]::ReadAllText($entry.Path)
            if ($content -match '(?m)^\s*namespace\s+(\S+?)\s*;\s*$') {
                if ($Matches[1] -ne $moduleName) {
                    throw "C# type file 'types/$base.cs' in module '$moduleName' declares namespace '$($Matches[1])' but must declare 'namespace $moduleName;' (its module full name). Run Format-Types."
                }
            }
            elseif ($content -match '(?m)^\s*namespace\s+(\S+?)\s*\{') {
                throw "C# type file 'types/$base.cs' in module '$moduleName' uses a block-scoped namespace '$($Matches[1])'; it must declare a file-scoped 'namespace $moduleName;'. Run Format-Types."
            }
            else {
                throw "C# type file 'types/$base.cs' in module '$moduleName' declares no namespace; it must declare 'namespace $moduleName;' (its module full name). Run Format-Types."
            }
            [pscustomobject]@{
                Module = $moduleName
                Base   = $base
                Type   = "$moduleName.$base"
                Key    = $entry.Key
                File   = "$folderName/types/$base.cs"
                Path   = $entry.Path
            }
        })
}
