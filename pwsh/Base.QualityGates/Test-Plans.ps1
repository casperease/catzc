function Test-Plans {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [Catzc.Base.QualityGates.PlansConfig] $Config = (Get-Config -Config plans),

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    # A relative -Path names a place in the repository, whatever folder the process stands in.
    $targets = @(foreach ($item in $Path) {
            if ([System.IO.Path]::IsPathRooted($item)) {
                [System.IO.Path]::GetFullPath($item)
            }
            else {
                [System.IO.Path]::GetFullPath((Join-Path $root $item))
            }
        })
    foreach ($target in $targets) {
        Assert-True ([System.IO.Directory]::Exists($target) -or
            [System.IO.File]::Exists($target)) -ErrorText "Test-Plans: '$target' does not exist."
    }
    # The folder holds the overlays the cross-file checks read whole, even when -Path names only some of its files.
    $folder = if ($targets.Count -eq 0) {
        Join-Path $root $Config.folder
    }
    elseif ([System.IO.Directory]::Exists($targets[0])) {
        $targets[0]
    }
    else {
        [System.IO.Path]::GetDirectoryName($targets[0])
    }
    Assert-True ([System.IO.Directory]::Exists($folder)) -ErrorText "Test-Plans: the plans folder '$folder' does not exist."
    $label = if ($targets.Count -gt 0) {
        [System.IO.Path]::GetFileName($folder.TrimEnd('\', '/'))
    }
    else {
        $Config.folder
    }

    # A plan is its file, its value-overlay row and its master chunk line; the overlays are read whole.
    $readLines = {
        param([string] $Name)
        $file = Join-Path $folder $Name
        if ([System.IO.File]::Exists($file)) {
            [System.IO.File]::ReadAllText($file) -split "`r?`n"
        }
    }
    $masterLines = @(& $readLines $Config.master_file)
    $valueLines = @(& $readLines $Config.value_file)

    # A check names an exported Verb-Noun command; any other cannot prove its step.
    $verbs = [System.Collections.Generic.HashSet[string]]::new([string[]] @((Get-Verb).Verb),
        [System.StringComparer]::OrdinalIgnoreCase)
    $commandPattern = '(?<![\w./\\-])(?<verb>[A-Z][a-z]+)-[A-Z][A-Za-z0-9]+(?![\w-]|\.\w)'
    $known = [System.Collections.Generic.Dictionary[string, bool]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $isKnown = {
        param([string] $Name)
        if (-not $known.ContainsKey($Name)) {
            $known[$Name] = @(Get-Command -Name $Name -CommandType Cmdlet, Function,
                Alias -ErrorAction Ignore | Where-Object {
                    $_.CommandType -ne 'Function' -or -not $_.Module -or $_.Module.ExportedCommands.ContainsKey($_.Name)
                }).Count -gt 0
        }
        $known[$Name]
    }

    $openCounts = Get-PlanOpenStepCount $folder -Config $Config
    $issues = [System.Collections.Generic.List[string]]::new()
    $plans = 0
    $tasks = 0
    $files = @(@(foreach ($target in @(if ($targets.Count -gt 0) {
                        $targets
                    }
                    else {
                        $folder
                    })) {
                if ([System.IO.Directory]::Exists($target)) {
                    Get-ChildPath $target -Depth 1 -File -Filter '*.md'
                }
                else {
                    $target
                }
            }) | Sort-Object -Unique)
    foreach ($file in $files) {
        $name = [System.IO.Path]::GetFileName($file)
        $where = "$label/$name"
        $add = {
            param([int] $Line, [string] $Rule, [string] $Message)
            $issues.Add("${where}:${Line} [$Rule] $Message")
        }
        if (-not $Config.Accepts($name)) {
            & $add 1 'ADR-REPO-PLANS-ONETOPICONEFILE' 'the name is not one the plans folder accepts (plan-<topic>.md, prompt-<topic>-continue.md, task-<topic>.md, …); a name never carries an order (ADR-REPO-FOLDERS-STABLEFILENAMES)'
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
                & $add ($i + 1) 'ADR-REPO-PLANS-MASTERANDTASKS' "'$($Matches[1])' names a task by a number; a task is named by its topic and the master's list carries the order"
            }
        }
        $hasHeading = {
            param([string] $Prefix)
            @($headings | Where-Object { $_.Text.StartsWith($Prefix,
                        [System.StringComparison]::OrdinalIgnoreCase) }).Count -gt 0
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
                    & $add 1 'ADR-REPO-PLANS-PLANHEAD'"the front matter is not YAML: $($_.Exception.Message)"
                }
            }
        }

        if ($isMaster) {
            foreach ($section in $Config.master_sections) {
                if (-not (& $hasHeading $section)) {
                    & $add 1 'ADR-REPO-PLANS-MASTERANDTASKS'"the master plan has no '## $section' section"
                }
            }
            continue
        }

        if ($isTask) {
            $tasks++
            if ($tasks -eq $Config.tasks_max + 1) {
                & $add 1 'ADR-REPO-PLANS-MASTERANDTASKS'"the folder holds more than the roof of $($Config.tasks_max) task files"
            }
            $block = if ($frontMatter -is [System.Collections.IDictionary] -and $frontMatter.Contains('task')) {
                $frontMatter['task']
            }
            if (-not ($block -is [System.Collections.IDictionary])) {
                & $add 1 'ADR-REPO-PLANS-MASTERANDTASKS'"the head has no 'task:' block"
            }
            else {
                foreach ($key in 'status', 'plans', 'value', 'blocked_on', 'targets') {
                    if (-not $block.Contains($key)) {
                        & $add 1 'ADR-REPO-PLANS-MASTERANDTASKS'"the task head misses '$key'"
                    }
                }
            }
            if (-not (& $hasHeading 'Steps')) {
                & $add 1 'ADR-REPO-PLANS-MASTERANDTASKS'"the task file has no '## Steps' section"
            }
            continue
        }

        $plans++
        $block = if ($frontMatter -is [System.Collections.IDictionary] -and $frontMatter.Contains('plan')) {
            $frontMatter['plan']
        }
        if (-not ($block -is [System.Collections.IDictionary])) {
            & $add 1 'ADR-REPO-PLANS-PLANHEAD'"the head has no 'plan:' block"
        }
        else {
            foreach ($key in $Config.head_required) {
                if (-not $block.Contains($key)) {
                    & $add 1 'ADR-REPO-PLANS-PLANHEAD'"the head misses '$key'"
                }
            }
            foreach ($key in @($block.Keys)) {
                if ($key -notin $Config.head_required -and $key -notin $Config.head_allowed) {
                    & $add 1 'ADR-REPO-PLANS-PLANHEAD'"the head key '$key' is outside the plan keys ($(($Config.head_required + $Config.head_allowed) -join ', '))"
                }
            }
            if ($block.Contains('status')) {
                $status = "$($block['status'])"
                if ($status -notin $Config.statuses) {
                    & $add 1 'ADR-REPO-PLANS-PLANHEAD'"status '$status' is not one of: $($Config.statuses -join ', ')"
                }
                elseif ($status -ceq 'blocked' -and -not ($block.Contains('blocked_on') -or
                        $block.Contains('waits_on'))) {
                    & $add 1 'ADR-REPO-PLANS-PLANHEAD'"a blocked plan names what blocks it in 'blocked_on' or 'waits_on'"
                }
            }
            if ($block.Contains('value') -and "$($block['value'])" -notin $Config.ranks) {
                & $add 1 'ADR-REPO-PLANS-PLANHEAD'"value '$($block['value'])' is not one of the ranks: $($Config.ranks -join ', ')"
            }
            if ($block.Contains('targets')) {
                $targets = @($block['targets'])
                if ($targets.Count -eq 0) {
                    & $add 1 'ADR-REPO-PLANS-PLANHEAD''targets names no path'
                }
                foreach ($target in $targets) {
                    $candidate = Join-Path $root "$target"
                    if (-not ([System.IO.File]::Exists($candidate) -or [System.IO.Directory]::Exists($candidate))) {
                        & $add 1 'ADR-REPO-PLANS-PLANHEAD'"target '$target' does not exist"
                    }
                }
            }
        }

        $items = @(Get-MarkdownListItem -Line $lines)
        $openCount = [int] $openCounts[$name]
        # A step count an overlay states is the plan's open steps, or it drifted; Format-Code rewrites it.
        $assertCount = {
            param([string] $Text, [string] $Overlay)
            $stated = Resolve-PlanStepCount -Text $Text
            if ($stated -and $stated.Count -ne $openCount) {
                & $add 1 'ADR-REPO-PLANS-THREEPARTS' "$Overlay says $($stated.Count) step(s), but the plan has $openCount open step(s)"
            }
        }

        $topic = [System.IO.Path]::GetFileNameWithoutExtension($name)
        $pointer = '^\s*-\s.*->\s*' + [regex]::Escape($name) + '\b'
        $chunk = @(Get-MarkdownListItem -Line $masterLines | Where-Object { $_.First -match $pointer }) |
            Select-Object -First 1
        if (-not $chunk) {
            & $add 1 'ADR-REPO-PLANS-THREEPARTS' "the plan has no chunk line in $($Config.master_file) ('- <chunk> -> ${name}: ...')"
        }
        else {
            & $assertCount $chunk.Text "its chunk line in $($Config.master_file)"
        }
        $row = '^\|[^|]*\|\s*' + [regex]::Escape($topic) + '\s*\|'
        $valueRow = $valueLines | Where-Object { $_ -match $row } | Select-Object -First 1
        if (-not $valueRow) {
            & $add 1 'ADR-REPO-PLANS-THREEPARTS' "the plan has no row in $($Config.value_file) ('| <value> | $topic | ...')"
        }
        else {
            $state = @($valueRow.Trim().Trim('|') -split '\|')[-1]
            & $assertCount $state "its row in $($Config.value_file)"
            # A row holds as many cells as its own table's header, so a lost cell never shifts columns unseen.
            $at = [array]::IndexOf($valueLines, $valueRow)
            while ($at -gt 0 -and $valueLines[$at - 1] -match '^\s*\|') {
                $at--
            }
            $header = $valueLines[$at]
            $cells = { param([string] $Text) @($Text.Trim().Trim('|') -split '(?<!\\)\|').Count }
            if ($header -and (& $cells $valueRow) -ne (& $cells $header)) {
                & $add 1 'ADR-REPO-PLANS-THREEPARTS' "its row in $($Config.value_file) has $(& $cells $valueRow) cell(s), but the table's header has $(& $cells $header)"
            }
        }

        foreach ($section in $Config.sections_required) {
            if (-not (& $hasHeading $section)) {
                & $add 1 'ADR-REPO-PLANS-ONESHAPE'"the plan has no '## $section' section"
            }
        }

        # A numbered line of the open steps section is a step, so it carries the checkbox the closing sweep counts.
        $inOpen = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^##\s') {
                $inOpen = $lines[$i] -match '^##\s+Open steps'
            }
            elseif ($inOpen -and $lines[$i] -match '^\d+\.\s' -and $lines[$i] -notmatch '^\d+\.\s+\[[ xX]\]') {
                & $add ($i + 1) 'ADR-REPO-PLANS-OPENSTEP' "the open step has no checkbox: `"$($lines[$i].Trim())`""
            }
        }

        # An open step is a `- [ ]` or `1. [ ]` list item, its continuation lines included; each names its check.
        foreach ($item in $items) {
            if ($item.First -notmatch '^\s*(-|\d+\.) \[ \]') {
                continue
            }
            if ($item.Text -notmatch '(?i)check:') {
                & $add $item.LineNumber 'ADR-REPO-PLANS-OPENSTEP' "the open step names no check: `"$($item.Text.Trim())`""
                continue
            }
            # The text after the last standalone check:, so catzc-gate: is never read as one.
            $check = [regex]::Match($item.Text, '(?is)^.*(?<![\w-])check:(?<check>.*)$').Groups['check'].Value
            foreach ($match in [regex]::Matches($check, $commandPattern)) {
                if ($verbs.Contains($match.Groups['verb'].Value) -and -not (& $isKnown $match.Value)) {
                    & $add $item.LineNumber 'ADR-REPO-PLANS-OPENSTEP' "the check names '$($match.Value)', which no module exports"
                }
            }
        }
    }

    Write-QualityGateReport -Subject plans -Title Test-Plans -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Files = $files.Count; Plans = $plans; Tasks = $tasks }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
