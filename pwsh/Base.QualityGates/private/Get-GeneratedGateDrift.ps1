function Get-GeneratedGateDrift {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Variants.GeneratedWriterRow] $Writer,

        [Parameter(Mandatory)]
        [Catzc.Base.Variants.GeneratedWriterRow[]] $Writers,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [Catzc.Base.Variants.GeneratedTarget[]] $Generated,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # A gate-checked writer has no dry run, so freshness is read from the commits: an input committed after the output it feeds is drift.
    $mine = @($Generated | Where-Object { $_.generator -ceq $Writer.name } | ForEach-Object path)
    if ($mine.Count -eq 0) {
        return
    }
    # An input is generated when another writer's output is that very glob; an authored input is the gate's to prove.
    $inputGlobs = [string[]] [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($Writer)
    $inputs = [System.Collections.Generic.HashSet[string]]::new($inputGlobs, [System.StringComparer]::Ordinal)
    $upstreamWriters = @($Writers | Where-Object { $_.name -cne $Writer.name -and @($_.outputs | Where-Object { $inputs.Contains($_.path) }).Count -gt 0 })
    $bySlide = @($inputGlobs | Where-Object { $_ -like '*.slide.md' }).Count -gt 0

    $globs = [System.Collections.Generic.List[string]]::new()
    $globs.AddRange([string[]] @($Writer.outputs | ForEach-Object path))
    foreach ($upstream in $upstreamWriters) {
        $globs.AddRange([string[]] @($upstream.outputs | ForEach-Object path))
    }
    if ($bySlide) {
        $globs.AddRange($inputGlobs)
    }
    $specs = @($globs | Select-Object -Unique | ForEach-Object { "`":(glob)$_`"" }) -join ' '
    $log = "$((Invoke-Executable "git -c core.quotepath=off log --no-renames --format=%x01%h --name-only -- $specs" -WorkingDirectory $RepositoryRoot -PassThru -Silent).Output)"
    $order = @{}
    $hashOf = @{}
    $position = -1
    $hash = ''
    foreach ($line in ($log -split "`r?`n")) {
        if ($line.StartsWith([string] [char] 1, [System.StringComparison]::Ordinal)) {
            $position++
            $hash = $line.Substring(1).Trim()
        }
        elseif ($line.Trim() -and -not $order.ContainsKey($line.Trim())) {
            $order[$line.Trim()] = $position
            $hashOf[$line.Trim()] = $hash
        }
    }

    $committed = @($mine | Where-Object { $order.ContainsKey($_) })
    if ($committed.Count -eq 0) {
        return
    }

    if ($bySlide) {
        # A slide output is judged on its own inputs: its slide file and the pictures that slide names.
        foreach ($file in $committed) {
            foreach ($named in @(Get-SlideInputPath -Path $file -RepositoryRoot $RepositoryRoot)) {
                if ($order.ContainsKey($named) -and $order[$named] -lt $order[$file]) {
                    "$named committed in $($hashOf[$named]) after $file"
                }
            }
        }
        return
    }

    $rendered = ($committed | ForEach-Object { $order[$_] } | Measure-Object -Minimum).Minimum
    foreach ($upstream in $upstreamWriters) {
        $newest = @($Generated | Where-Object { $_.generator -ceq $upstream.name -and $order.ContainsKey($_.path) } | ForEach-Object path | Sort-Object { $order[$_] } | Select-Object -First 1)
        if ($newest.Count -eq 1 -and $order[$newest[0]] -lt $rendered) {
            "$($upstream.name) committed its output in $($hashOf[$newest[0]]) after the last commit of these outputs"
        }
    }
}
