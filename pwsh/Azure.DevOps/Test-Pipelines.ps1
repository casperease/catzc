function Test-Pipelines {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $place = (Get-Track -Name vendor_ado.pipelines).places[0]
    $pipelinesRoot = if ($Path) {
        $Path
    }
    else {
        Join-Path (Get-RepositoryRoot) $place
    }
    Assert-PathExist $pipelinesRoot -PathType Container
    $templatePrefix = "/$place/"

    $typePrefixes = @('cron', 'ci', 'cd', 'cde', 'deploy', 'input')
    $templateFolders = @('steps', 'jobs', 'stages', 'variables', 'extends')
    # The structural kind we expect a fragment folder to hold (extends/ is whole-pipeline — any body).
    $folderKind = @{ steps = 'Steps'; jobs = 'Jobs'; stages = 'Stages'; variables = 'Variables' }

    $records = @(Get-AdoYamlFiles -Path $pipelinesRoot)
    $violations = [System.Collections.Generic.List[string]]::new()

    function New-Violation {
        param($RelativePath, $Rule, $Message)
        "[$Rule] $place/${RelativePath}: $Message"
    }

    foreach ($record in $records) {
        $rel = $record.RelativePath
        $dir = ($record.RelativeDirectory -replace '\\', '/').Trim('/')
        $name = Split-Path $rel -Leaf
        $extension = [System.IO.Path]::GetExtension($name).ToLowerInvariant()
        $segments = @()
        if ($dir) {
            $segments = @($dir -split '/')
        }
        $topFolder = if ($segments.Count -ge 1) {
            $segments[0]
        }
        else {
            ''
        }

        # A parse failure is itself a violation — a pipeline that ADO cannot read is not compliant.
        if ($record.ParseError) {
            $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-ADO-NAME' -Message "YAML failed to parse: $($record.ParseError)"))
            continue
        }

        # Executable YAML under pipelines/ is .yaml, never .yml.
        if ($extension -eq '.yml') {
            $violations.Add((New-Violation -RelativePath $rel -Rule 'FDR-PIPELINE-EXECUTABLEYAMLEXTENSION' -Message "Executable pipeline YAML must be '.yaml', not '.yml'."))
            continue
        }

        if ($segments.Count -eq 0) {
            # At the root of pipelines/ a file is an entry point, so its name starts with a valid type token.
            $prefix = ($name -split '-', 2)[0]
            if ($prefix -notin $typePrefixes) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'FDR-PIPELINE-TYPEPREFIX' -Message "Pipeline name must start with a type ($($typePrefixes -join ' | ')); got '$prefix'."))
            }
        }
        else {
            # In a subfolder the name must be a per-kind template folder from the closed set, one level deep.
            if ($topFolder -notin $templateFolders) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-ADO-NAME-TEMPLATEKINDFOLDER' -Message "Template folder '$topFolder' is not one of: $($templateFolders -join ' | ')."))
            }
            elseif ($segments.Count -gt 1) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-ADO-NAME-FLATPIPELINESFOLDER' -Message "Templates live directly in '$topFolder/', not nested deeper ('$dir/')."))
            }
            else {
                # A structural pipeline has no business inside a template folder.
                if ($record.Classification -eq 'Pipeline') {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-ADO-NAME-FLATPIPELINESFOLDER' -Message "A pipeline (trigger/pr/… shape) must live flat in $place/, not inside '$topFolder/'."))
                }
                # A fragment's structural kind must match its folder; extends/ is exempt.
                elseif ($folderKind.ContainsKey($topFolder) -and $record.TemplateType -and
                    "$($record.TemplateType)" -ne $folderKind[$topFolder]) {
                    $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-ADO-NAME-TEMPLATEKINDFOLDER' -Message "A '$($record.TemplateType)' template does not belong in '$topFolder/' (expected $($folderKind[$topFolder]))."))
                }
            }
        }

        # Template references are absolute (/pipelines/<kind>/<name>.yaml), never relative.
        foreach ($ref in (Get-PipelineTemplateReference -Path $record.Path)) {
            if (-not $ref.StartsWith($templatePrefix, [System.StringComparison]::Ordinal)) {
                $violations.Add((New-Violation -RelativePath $rel -Rule 'ADR-ADO-TEMPLATE-ABSOLUTEPATHS' -Message "Template reference '$ref' must be an absolute path starting with $templatePrefix."))
            }
        }
    }

    Write-QualityGateReport -Subject pipelines -Title Test-Pipelines -Issues $violations.ToArray() `
        -Facts ([ordered]@{ Files = $records.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
