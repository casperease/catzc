@{
    Severity            = @('Error', 'Warning', 'Information')

    # Run the built-in rules too, not only CustomRulePath. Without this, specifying CustomRulePath
    # makes PSScriptAnalyzer run ONLY the custom rules — every built-in Rules{} entry and ExcludeRules
    # line below is silently ignored. This flag is what makes this file the single source of truth.
    IncludeDefaultRules = $true

    CustomRulePath      = @(
        'automation/.scriptanalyzer/VariableCasing.psm1'
        'automation/.scriptanalyzer/NeverDependOnPwd.psm1'
        'automation/.scriptanalyzer/FunctionLength.psm1'
        'automation/.scriptanalyzer/NoWriteErrorOrWarning.psm1'
        'automation/.scriptanalyzer/NoAzModuleNaming.psm1'
        'automation/.scriptanalyzer/NoAutomaticVariableMisuse.psm1'
        'automation/.scriptanalyzer/NoForEachObjectControlFlow.psm1'
        'automation/.scriptanalyzer/NoRawVsoCommand.psm1'
        'automation/.scriptanalyzer/NoRawPipelineDetection.psm1'
        'automation/.scriptanalyzer/NoRawInformationStream.psm1'
        'automation/.scriptanalyzer/SpellOutIdentifiers.psm1'
    )

    ExcludeRules        = @(
        # ── Permanently excluded ────────────────────────────────────
        # We use UTF-8 without BOM — BOM causes issues with many tools
        'PSUseBOMForUnicodeEncodedFile'
        # Too many false positives on lightweight functions (Reset-, New-, etc.)
        'PSUseShouldProcessForStateChangingFunctions'
        # Plural nouns are often more natural (Import-AllModules, Get-Items, etc.)
        'PSUseSingularNouns'
        # False positive on Get-ChildItem with -Filter/-File/-Directory parameter sets
        'PSUseCmdletCorrectly'
        # Runtime return types rarely match declared OutputType (e.g. @() returns System.Array)
        'PSUseOutputTypeCorrectly'
        # Crashes under concurrent sharded analysis (Get-ScriptAnalyzerDiagnostics / the L2 analyzer test).
        # Its AnalyzeScript calls PSScriptAnalyzer's thread-unsafe helper runspace
        # (Helper.GetExportedFunction -> CommandInfo.ResolveParameter), which intermittently throws a
        # NullReferenceException when ~10 analyzer processes contend for CPU — root-caused from the captured
        # stack trace, reproduced in ~25% of full-tree runs and eliminated (0/15) by this one exclusion. The
        # rule only flags RESERVED CHARACTERS IN CMDLET NAMES, which one-function-per-file Verb-Noun naming
        # (enforced by folder conventions and custom rules) already precludes — so it is pure dead weight here.
        # Sibling rules that use the same helper path (PSReservedParams, PSUseApprovedVerbs) do NOT trip the
        # NRE and stay enabled.
        'PSReservedCmdletChar'
    )

    Rules               = @{
        # Every rule is spelled out in full so you can see at a glance what is on/off and what each
        # option is. Read the status from the Enable line:
        #   Enable = $true                 -> active
        #   Enable = $false  # OFF: …      -> intentionally off for good (terse reason here, detail above)
        #   Enable = $false  # STAGED: …   -> temporarily off pending cleanup (see ExcludeRules burn-down)
        # A fully commented-out rule block is an opt-in rule left as a ready-to-enable template.

        # ── On by default in PSScriptAnalyzer ───────────────────────

        # Requires comment-based help (.SYNOPSIS etc.) on exported functions.
        # ExportedOnly limits this to public functions only.
        PSProvideCommentHelp                      = @{
            Enable                  = $true
            ExportedOnly            = $true
            BlockComment            = $true
            VSCodeSnippetCorrection = $false
            Placement               = 'before'
        }

        # Flags function parameters that are declared but never used in the body.
        # CommandsToTraverse lists cmdlets whose scriptblock params should be checked too.
        # Currently gated off via the ExcludeRules burn-down above; this config is kept so removing
        # that one line is all it takes to activate the rule.
        PSReviewUnusedParameter                   = @{
            Enable             = $true  # STAGED: gated by ExcludeRules (71 violations)
            CommandsToTraverse = @()
        }

        # Warns when a function shadows a built-in cmdlet name.
        # PowerShellVersion scopes which built-ins to check against.
        PSAvoidOverwritingBuiltInCmdlets          = @{
            Enable            = $true
            PowerShellVersion = @('core-6.1.0-windows', 'core-6.1.0-linux', 'core-6.1.0-macos')
        }

        # Flags use of aliases (like % instead of ForEach-Object) in scripts.
        # allowlist permits specific aliases you want to keep.
        PSAvoidUsingCmdletAliases                 = @{
            Enable    = $true
            allowlist = @()
        }

        # Checks that cmdlets used in your code exist in the target PowerShell version.
        # compatibility lists platform profiles to validate against.
        #
        # What we know:
        #   - Validates code against the win + ubuntu profiles below (cross-platform check).
        #   - Was DEAD before IncludeDefaultRules = $true (CustomRulePath without that flag runs only
        #     custom rules), so it never actually checked anything — disabling is no regression.
        #   - When it runs, PSScriptAnalyzer merges the target profiles into a single ~42 MB
        #     union_<hash>.json written INSIDE automation/.vendor/PSScriptAnalyzer/.../
        #     compatibility_profiles/. That dir must stay pristine (see ADRs / .gitattributes) and the
        #     file is untracked, so it shows up as a stray 42 MB blob after every fresh run.
        #   - With PSUseCompatibleTypes it is the slowest thing here: enabling both took the L2 analyzer
        #     test from ~28 s to ~48 s.
        #
        # To re-introduce:
        #   1. Set Enable = $true here and on PSUseCompatibleTypes (re-enable them as a pair).
        #   2. The first run rebuilds union_<hash>.json in .vendor. The hash is keyed off the profile
        #      list, so it is stable while these profiles are unchanged — build once, then commit it
        #      (mark `binary` in .gitattributes given the size) to stop the churn. Cost: ~42 MB repo bloat.
        #   3. Confirm the ~20 s/run slowdown is acceptable. We did NOT measure whether that is a one-time
        #      build vs a per-run load+compare (each shard process loads the 42 MB profile) — measure
        #      first, because if it is per-run, committing the cache does not buy back the speed.
        #   4. Re-check that win + ubuntu are the platforms you actually target.
        PSUseCompatibleCmdlets                    = @{
            Enable        = $false  # OFF: writes 42 MB cache into .vendor + slowest rule; see note above
            compatibility = @(
                'win-4_x64_10.0.18362.0_7.0.0_x64_3.1.2_core'
                'ubuntu_x64_18.04_7.0.0_x64_3.1.2_core'
            )
        }

        # ── Off by default in PSScriptAnalyzer (opt-in) ─────────────
        # Spelled out with an explicit Enable. Fully commented-out blocks further down are templates:
        # uncomment and set Enable = $true to activate.

        # Aligns assignment operators (=) vertically in consecutive assignments
        # and hashtable entries for visual consistency.
        # Pairs with PSUseConsistentWhitespace's IgnoreAssignmentOperatorInsideHashTable = $true, which
        # stops CheckOperator flagging the multiple spaces this alignment introduces. VS Code's "Format
        # Document" aligns the same way via powershell.codeFormatting.alignPropertyValuePairs, so editor,
        # Format-Automation, and analyzer all agree on aligned '='.
        # History: this was off because enabling it made Invoke-Formatter throw internally and silently
        # return text UNCHANGED. That upstream bug is fixed as of the vendored PSScriptAnalyzer 1.25.0
        # (verified: aligns hashtables and applies other formatting without throwing) — re-enabled here.
        PSAlignAssignmentStatement                = @{
            Enable                                  = $true
            CheckHashtable                          = $true
            AlignHashtableKvpWithInterveningComment = $true
            CheckEnum                               = $true
            AlignEnumMemberWithInterveningComment   = $true
            IncludeValuelessEnumMembers             = $true
        }

        # Flags use of the ! operator — prefers -not for readability.
        PSAvoidExclaimOperator                    = @{
            Enable = $true
        }

        # Flags positional arguments — prefers named parameters for readability
        # (e.g. Copy-Item -Path x -Destination y over Copy-Item x y).
        # CommandAllowList is the escape hatch: commands listed here may be called positionally without
        # being flagged. It is the command-level analogue of VariableCasing's $script:skipVariables — a
        # curated set of well-known commands whose positional form is idiomatic and unambiguous. Join-Path
        # is the canonical case: `Join-Path $a $b $c` reads better than the named form and is universally
        # understood. Keep this list short and only for commands where positional use genuinely aids
        # readability; add a command here rather than sprinkling positional calls past the reviewer.
        PSAvoidUsingPositionalParameters          = @{
            Enable           = $true
            CommandAllowList = @(
                'Join-Path'
            )
        }

        # Warns when a line exceeds MaximumLineLength characters.
        # PSAvoidLongLines = @{
        #     Enable            = $true
        #     MaximumLineLength = 120
        # }

        # Flags semicolons used as line terminators — PowerShell doesn't need them.
        PSAvoidSemicolonsAsLineTerminators        = @{
            Enable = $true
        }

        # Flags double-quoted strings that contain no variable expansion or escapes,
        # suggesting single quotes instead.
        PSAvoidUsingDoubleQuotesForConstantString = @{
            Enable = $true
        }

        # Enforces consistent placement of closing braces (}).
        # IgnoreOneLineBlock = $false: also break one-line blocks (if ($x) { ... }) across lines, so no
        # block keeps its { } on a single line. Keep in sync with the VS Code
        # powershell.codeFormatting.ignoreOneLineBlock = false setting.
        PSPlaceCloseBrace                         = @{
            Enable             = $true
            NoEmptyLineBefore  = $false
            IgnoreOneLineBlock = $false
            NewLineAfter       = $true
        }

        # Enforces consistent placement of opening braces ({).
        # OnSameLine = K&R style, $false = Allman style.
        # IgnoreOneLineBlock = $false: see PSPlaceCloseBrace — expands one-line blocks onto multiple lines.
        PSPlaceOpenBrace                          = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $false
        }

        # Checks that commands used in your code exist in target PowerShell profiles.
        # TargetProfiles lists platform/version profiles to validate against.
        # PSUseCompatibleCommands = @{
        #     Enable         = $true
        #     TargetProfiles = @()
        #     IgnoreCommands = @()
        # }

        # Checks that syntax used is valid in older PowerShell versions.
        # TargetVersions lists the versions to validate against.
        # PSUseCompatibleSyntax = @{
        #     Enable         = $true
        #     TargetVersions = @()
        # }

        # Checks that .NET types used exist in target PowerShell profiles.
        # Off for the same reasons, and via the same re-introduction steps, as PSUseCompatibleCmdlets
        # above (read that block first). This is the rule that actually emits the ~42 MB union_<hash>.json
        # type profile into automation/.vendor. Re-enable it together with PSUseCompatibleCmdlets.
        PSUseCompatibleTypes                      = @{
            Enable         = $false  # OFF: emits 42 MB cache into .vendor; see PSUseCompatibleCmdlets
            TargetProfiles = @(
                'win-4_x64_10.0.18362.0_7.0.0_x64_3.1.2_core'
                'ubuntu_x64_18.04_7.0.0_x64_3.1.2_core'
            )
            IgnoreTypes    = @()
        }

        # Enforces consistent indentation (spaces vs tabs, indent size).
        # PipelineIndentation controls how continuation lines in pipelines indent. Keep this in sync with
        # .vscode/settings.json `powershell.codeFormatting.pipelineIndentationStyle`, or Format Document
        # and the analyzer disagree and you get "Indentation not consistent" after formatting.
        PSUseConsistentIndentation                = @{
            Enable              = $true
            IndentationSize     = 4
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            Kind                = 'space'
        }

        # Warns when the same parameter set name appears in multiple functions,
        # which can cause confusion.
        # PSUseConsistentParameterSetName = @{
        #     Enable = $true
        # }

        # Enforces that all parameters use either param() blocks or function(args)
        # style consistently. ParamBlock = every function declares its parameters in a param() block,
        # not inline as function Foo($a). Not auto-fixable by Invoke-Formatter.
        PSUseConsistentParametersKind             = @{
            Enable         = $true
            ParametersKind = 'ParamBlock'
        }

        # Enforces consistent whitespace around braces, parens, operators, pipes,
        # and separators.
        PSUseConsistentWhitespace                 = @{
            Enable                                  = $true
            CheckInnerBrace                         = $true
            CheckOpenBrace                          = $true
            CheckOpenParen                          = $true
            CheckOperator                           = $true
            CheckPipe                               = $true
            CheckPipeForRedundantWhitespace         = $false
            CheckSeparator                          = $true
            CheckParameter                          = $false
            # $true: allow vertical alignment of '=' inside hashtables (multiple spaces before the
            # operator). VS Code's "Format Document" aligns hashtable key/value pairs via
            # powershell.codeFormatting.alignPropertyValuePairs (on by default), so flagging the
            # resulting alignment would make the formatter and analyzer disagree on every format pass.
            IgnoreAssignmentOperatorInsideHashTable = $true
        }

        # Warns when code doesn't run under Constrained Language Mode (CLM),
        # used in locked-down environments like AppLocker/WDAC.
        # PSUseConstrainedLanguageMode = @{
        #     Enable           = $true
        #     IgnoreSignatures = $false
        # }

        # Fixes casing of commands, keywords, and operators to match their
        # canonical definitions (e.g., ForEach-Object not foreach-object).
        # Produces false positives on *parameter* casing inside Pester test bodies — it misattributes a
        # call's -Name argument (e.g. Set-Foo -Name) to the enclosing It/Describe and claims the canonical
        # casing is lowercase 'name'. The test analyzes with Pester loaded, so it would fail (and an
        # autofix could wrongly rewrite -Name to -name). Re-enable if upstream fixes it.
        PSUseCorrectCasing                        = @{
            Enable        = $false  # OFF: false positives on Pester param casing; see note above
            CheckCommands = $true
            CheckKeyword  = $true
            CheckOperator = $true
        }

        # Warns when a pipeline parameter accepts an array — suggests accepting
        # single values and using the pipeline for collections instead.
        PSUseSingleValueFromPipelineParameter     = @{
            Enable = $true
        }
    }
}
