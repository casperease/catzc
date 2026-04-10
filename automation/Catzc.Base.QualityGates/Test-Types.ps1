<#
.SYNOPSIS
    Asserts every C# type source declares the file-scoped namespace of its module folder.
.DESCRIPTION
    The poka-yoke gate for the C# types (ADR native-csharp-types). Module identity lives in the folder
    (automation/<Module>/types/<Type>.cs); the `namespace <Module>;` line in each source is a derived mirror
    that Format-Types maintains. This gate fails when the two disagree — a file with no namespace, the wrong
    namespace, or a block-scoped namespace — so a move/rename can never ship with the namespace out of sync.
    Run Format-Types to fix what this reports.

    The matching declared namespace is also what lets the editor's C# toolchain compile and analyze these
    files (no false CA1050), so passing this gate keeps the in-editor feedback aligned with the rules.
.PARAMETER Path
    One or more files or directories to check. Defaults to every automation/<Module>/types/*.cs file.
.PARAMETER PassThru
    Return a result object ({ ViolationCount, Violations }) instead of throwing.
.OUTPUTS
    Throws on any violation; with -PassThru, returns the result object.
.EXAMPLE
    Test-Types
.EXAMPLE
    $result = Test-Types -PassThru; $result.ViolationCount
#>
function Test-Types {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
            if (Test-Path -Path $item -PathType Container) {
                Get-ChildItem -Path $item -Recurse -Filter '*.cs' -File |
                    ForEach-Object { $files.Add($_.FullName) }
            }
            else {
                $files.Add((Resolve-Path -Path $item).Path)
            }
        }
    }
    else {
        $automationRoot = Join-Path $root 'automation'
        Get-ChildItem -Path $automationRoot -Directory |
            Where-Object { $_.Name -notmatch '^\.' } |
            ForEach-Object {
                $typesPath = Join-Path $_.FullName 'types'
                if (Test-Path $typesPath) {
                    Get-ChildItem -Path $typesPath -Filter '*.cs' -File |
                        ForEach-Object { $files.Add($_.FullName) }
                    }
                }
    }

    $violations = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        $module = Split-Path -Path (Split-Path -Path (Split-Path -Path $file -Parent) -Parent) -Leaf
        $content = [System.IO.File]::ReadAllText($file)

        $relative = $file.Substring($root.Length).TrimStart('\', '/') -replace '\\', '/'
        if ($content -match '(?m)^\s*namespace\s+(\S+?)\s*;\s*$') {
            if ($Matches[1] -ne $module) {
                $violations.Add("${relative}: declares namespace '$($Matches[1])' but its module folder is '$module'.")
            }
        }
        elseif ($content -match '(?m)^\s*namespace\s+(\S+?)\s*\{') {
            $violations.Add("${relative}: uses a block-scoped namespace '$($Matches[1])'; types use a file-scoped 'namespace $module;'.")
        }
        else {
            $violations.Add("${relative}: declares no namespace; expected file-scoped 'namespace $module;'.")
        }
    }

    if ($violations.Count -eq 0) {
        Write-Message "All $($files.Count) C# type file(s) declare the namespace of their module folder."
    }
    else {
        Write-Message "$($violations.Count) of $($files.Count) C# type file(s) have a namespace mismatch (run Format-Types)."
    }

    if ($PassThru) {
        return [pscustomobject]@{
            ViolationCount = $violations.Count
            Violations     = $violations.ToArray()
        }
    }

    if ($violations.Count -gt 0) {
        throw "Test-Types failed: $($violations.Count) C# type file(s) have a namespace mismatch — run Format-Types:`n$($violations -join "`n")"
    }
}
