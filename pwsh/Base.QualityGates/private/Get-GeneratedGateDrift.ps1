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

    # A gate-checked writer has no dry run, so freshness is read from the commits: a generated input committed after its outputs is drift.
    $rowOf = @{}
    foreach ($row in $Writers) {
        $rowOf[$row.name] = $row
    }
    $generatedPaths = [string[]] @($Generated | ForEach-Object path)
    $generatorOf = @{}
    foreach ($target in $Generated) {
        $generatorOf[$target.path] = $target.generator
    }
    # A writer's committed files as pathspecs: its globs, less what another writer claims under them, by that writer's glob or by path.
    $pathspec = {
        param([Catzc.Base.Variants.GeneratedWriterRow] $Row)
        $globs = [string[]] @($Row.outputs | ForEach-Object path)
        $under = [Catzc.Base.Objects.GlobPattern]::MatchingPaths($globs, $generatedPaths)
        if (@($under | Where-Object { $generatorOf[$_] -ceq $Row.name }).Count -eq 0) {
            return
        }
        $specs = [System.Collections.Generic.List[string]]::new()
        foreach ($glob in $globs) {
            $specs.Add("`":(glob)$glob`"")
        }
        $excluded = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($file in $under) {
            $owner = $generatorOf[$file]
            if ($owner -ceq $Row.name) {
                continue
            }
            $exclusions = @(if ($rowOf.ContainsKey($owner)) {
                    $rowOf[$owner].outputs | ForEach-Object { "`":(exclude,glob)$($_.path)`"" }
                }
                else {
                    "`":(exclude,literal)$file`""
                })
            foreach ($exclusion in $exclusions) {
                if ($excluded.Add($exclusion)) {
                    $specs.Add($exclusion)
                }
            }
        }
        $specs -join ' '
    }
    $git = {
        param([string] $Root, [string] $Arguments)
        "$((Invoke-Executable "git $Arguments" -WorkingDirectory $Root -PassThru -Silent).Output)".Trim()
    }

    $outputs = & $pathspec $Writer
    if (-not $outputs) {
        return
    }
    $rendered = & $git $RepositoryRoot "log -1 --format=%H -- $outputs"
    if (-not $rendered) {
        return
    }
    # An input is generated when another writer's output is that very glob; an authored input is the gate's to prove.
    $inputs = [System.Collections.Generic.HashSet[string]]::new([string[]] [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($Writer), [System.StringComparer]::Ordinal)
    foreach ($upstream in $Writers) {
        if ($upstream.name -ceq $Writer.name -or @($upstream.outputs | Where-Object { $inputs.Contains($_.path) }).Count -eq 0) {
            continue
        }
        $spec = & $pathspec $upstream
        if (-not $spec) {
            continue
        }
        $later = & $git $RepositoryRoot "log -1 --format=%h $rendered..HEAD -- $spec"
        if ($later) {
            "$($upstream.name) committed its output in $later after the last commit of these outputs"
        }
    }
}
