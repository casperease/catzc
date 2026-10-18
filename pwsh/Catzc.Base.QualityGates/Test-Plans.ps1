function Test-Plans {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $Path,

        [Catzc.Base.QualityGates.PlansConfig] $Config = (Get-Config -Config plans),

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $folder = if ($Path) {
        [System.IO.Path]::GetFullPath($Path)
    }
    else {
        Join-Path $root $Config.folder
    }
    Assert-True ([System.IO.Directory]::Exists($folder)) -ErrorText "Test-Plans: the plans folder '$folder' does not exist."
    $label = if ($Path) {
        [System.IO.Path]::GetFileName($folder)
    }
    else {
        $Config.folder
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    $plans = 0
    $tasks = 0
    $files = @(Get-ChildPath $folder -Depth 1 -File -Filter '*.md' | Sort-Object)
    foreach ($file in $files) {
        $name = [System.IO.Path]::GetFileName($file)
        $where = "$label/$name"
        $add = {
            param([int] $Line, [string] $Rule, [string] $Message)
            $issues.Add("${where}:${Line} [ADR-REPO-PLANS#${Rule}] $Message")
        }
        if (-not $Config.Accepts($name)) {
            & $add 1 1 'the name is not one the plans folder accepts (plan-<topic>.md, prompt-<topic>-continue.md, task-<topic>.md, …); a name never carries an order (ADR-REPO-FOLDERS-STABLEFILENAMES)'
            continue
        }
        $text = [System.IO.File]::ReadAllText($file)
        $lines = $text -split "`r?`n"
        $headings = [System.Collections.Generic.List[pscustomobject]]::new()
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^##\s+(?<text>.+?)\s*$') {
                $headings.Add([pscustomobject]@{ Line = $i + 1; Text = $Matches['text'] })
            }
        }
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -cmatch '\b(task[0-9]{3}|T[0-9]{3})\b') {
                & $add ($i + 1) 8 "'$($Matches[1])' names a task by a number; a task is named by its topic and the master's list carries the order"
            }
        }
        $hasHeading = {
            param([string] $Prefix)
            @($headings | Where-Object { $_.Text.StartsWith($Prefix, [System.StringComparison]::OrdinalIgnoreCase) }).Count -gt 0
        }

        $isMaster = $name -ceq $Config.master_file
        $isTask = $name -like 'task-*.md'
        $isPlan = -not $isMaster -and -not $isTask -and $name -like 'plan-*.md'
        if (-not ($isMaster -or $isTask -or $isPlan)) {
            continue
        }

        # The front matter: the block between the first two fences, read as YAML.
        $frontMatter = $null
        if ($lines.Count -gt 2 -and $lines[0] -ceq '---') {
            $end = [System.Array]::IndexOf($lines, '---', 1)
            if ($end -gt 0) {
                try {
                    $frontMatter = ($lines[1..($end - 1)] -join "`n") | ConvertFrom-Yaml -Ordered
                }
                catch {
                    & $add 1 2 "the front matter is not YAML: $($_.Exception.Message)"
                }
            }
        }

        if ($isMaster) {
            foreach ($section in $Config.master_sections) {
                if (-not (& $hasHeading $section)) {
                    & $add 1 8 "the master plan has no '## $section' section"
                }
            }
            continue
        }

        if ($isTask) {
            $tasks++
            if ($tasks -eq $Config.tasks_max + 1) {
                & $add 1 8 "the folder holds more than the roof of $($Config.tasks_max) task files"
            }
            $block = if ($frontMatter -is [System.Collections.IDictionary] -and $frontMatter.Contains('task')) {
                $frontMatter['task']
            }
            if (-not ($block -is [System.Collections.IDictionary])) {
                & $add 1 8 "the head has no 'task:' block"
            }
            else {
                foreach ($key in 'status', 'plans', 'value', 'blocked_on', 'targets') {
                    if (-not $block.Contains($key)) {
                        & $add 1 8 "the task head misses '$key'"
                    }
                }
            }
            if (-not (& $hasHeading 'Steps')) {
                & $add 1 8 "the task file has no '## Steps' section"
            }
            continue
        }

        $plans++
        $block = if ($frontMatter -is [System.Collections.IDictionary] -and $frontMatter.Contains('plan')) {
            $frontMatter['plan']
        }
        if (-not ($block -is [System.Collections.IDictionary])) {
            & $add 1 2 "the head has no 'plan:' block"
        }
        else {
            foreach ($key in $Config.head_required) {
                if (-not $block.Contains($key)) {
                    & $add 1 2 "the head misses '$key'"
                }
            }
            foreach ($key in @($block.Keys)) {
                if ($key -notin $Config.head_required -and $key -notin $Config.head_allowed) {
                    & $add 1 2 "the head key '$key' is outside the plan keys ($(($Config.head_required + $Config.head_allowed) -join ', '))"
                }
            }
            if ($block.Contains('status')) {
                $status = "$($block['status'])"
                if ($status -notin $Config.statuses) {
                    & $add 1 2 "status '$status' is not one of: $($Config.statuses -join ', ')"
                }
                elseif ($status -ceq 'blocked' -and -not ($block.Contains('blocked_on') -or $block.Contains('waits_on'))) {
                    & $add 1 2 "a blocked plan names what blocks it in 'blocked_on' or 'waits_on'"
                }
            }
            if ($block.Contains('value') -and "$($block['value'])" -notin $Config.ranks) {
                & $add 1 2 "value '$($block['value'])' is not one of the ranks: $($Config.ranks -join ', ')"
            }
            if ($block.Contains('targets')) {
                $targets = @($block['targets'])
                if ($targets.Count -eq 0) {
                    & $add 1 2 'targets names no path'
                }
                foreach ($target in $targets) {
                    $candidate = Join-Path $root "$target"
                    if (-not ([System.IO.File]::Exists($candidate) -or [System.IO.Directory]::Exists($candidate))) {
                        & $add 1 2 "target '$target' does not exist"
                    }
                }
            }
        }

        foreach ($section in $Config.sections_required) {
            if (-not (& $hasHeading $section)) {
                & $add 1 3 "the plan has no '## $section' section"
            }
        }

        # An open step is the `- [ ]` line with its indented continuation lines; each names its check.
        $stepLine = 0
        $step = $null
        $flush = {
            if ($stepLine -gt 0 -and $step -notmatch '(?i)check:') {
                & $add $stepLine 4 "the open step names no check: `"$($step.Trim())`""
            }
        }
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ($line -match '^\s*- \[ \]') {
                & $flush
                $stepLine = $i + 1
                $step = $line
            }
            elseif ($stepLine -gt 0 -and $line -match '^\s{2,}\S' -and $line -notmatch '^\s*- \[') {
                $step += ' ' + $line.Trim()
            }
            elseif ($stepLine -gt 0) {
                & $flush
                $stepLine = 0
                $step = $null
            }
        }
        & $flush
    }

    Write-QualityGateReport -Subject plans -Title Test-Plans -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Files = $files.Count; Plans = $plans; Tasks = $tasks }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
