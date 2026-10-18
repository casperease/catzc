# ---
# catzc:
#   immutable:
#     with_body_sha: "0e656aab9aa6"
#     repo_status: locked
#     path: importer.sh
#     source: pwsh/Catzc.Base.RootConfig/assets/root/importer.sh
#     role: script
#     language: bash
#     filetype: sh
#     generator: pwsh/Catzc.Base.RootConfig/Build-RootConfig.ps1
# ---

# shellcheck shell=bash
# importer.sh — brings catzc to a bash (or zsh) session. catzc's commands are PowerShell, so this defines one dispatcher,
# `cats`, that runs any catzc command through pwsh with the repository's importer loaded
# (ADR-AUTO-ENGINE, docs/adr/automation/execution-engines.md):
#
#   source ./importer.sh                                  # must be sourced, not run
#   cats                                                  # lists the catzc commands
#   cats Get-RepositoryRoot
#   cats Test-Automation -Modules Catzc.Base.Repository -MaxLevel 2
#
# An argument that starts with '-' passes through as a parameter name; every other argument after the command is passed
# as one PowerShell literal, quoted the PowerShell way, so a value with spaces or a quote stays one value. A command with a
# command contract is checked first against importer-commands.sh, the lookup generated beside this file: an unknown parameter,
# a missing mandatory one or a value not of the contract's type fails before pwsh starts, a switch passes as a flag and an int
# unquoted (ADR-REPO-CMDCONTRACT#5); CATZC_COMMAND_LOOKUP names another lookup, for a test. Every call
# starts pwsh non-interactively and imports catzc, so it pays the import time; for many commands in a row, start pwsh
# and dot-source importer.ps1 instead.
#
# CATZC_IMPORTER names the PowerShell entry `cats` loads; unset, it is this repository's importer.ps1. A test run sets
# it to a build's Import-Catzc.ps1, so a bash session drives the build.

# Sourced only: `return` works at the top level of a sourced file and fails in a script that was run.
(return 0 2>/dev/null) || {
    echo "importer.sh must be sourced, not run: source ./importer.sh" >&2
    exit 1
}

# The repository root: the folder of this file, in the form pwsh reads (C:/... under Git Bash on Windows).
if [ -n "${ZSH_VERSION:-}" ]; then
    # zsh's own form for the sourced file's path; this branch runs only under zsh, where it is valid.
    # shellcheck disable=SC2296
    _catzc_root="$(cd "$(dirname "${(%):-%x}")" && pwd)"
else
    _catzc_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if command -v cygpath >/dev/null 2>&1; then
    _catzc_root="$(cygpath -m "$_catzc_root")"
fi

# One PowerShell single-quoted literal: a quote inside is doubled.
_catzc_literal() {
    printf "'%s'" "$(printf '%s' "$1" | sed "s/'/''/g")"
}

# cats [Command] [arguments...] — runs a catzc command through pwsh; with no arguments, lists the catzc commands.
cats() {
    _catzc_pwsh="$(command -v pwsh)" || {
        echo "cats: pwsh is not on PATH; catzc runs on PowerShell 7 (https://aka.ms/powershell)." >&2
        return 127
    }
    _catzc_load=". $(_catzc_literal "${CATZC_IMPORTER:-$_catzc_root/importer.ps1}") *> \$null"
    if [ "$#" -eq 0 ]; then
        "$_catzc_pwsh" -NoProfile -NonInteractive -Command \
            "$_catzc_load; Get-Command -Module 'Catzc.*' -CommandType Function | Sort-Object Name | ForEach-Object Name"
        return
    fi
    _catzc_text="$1"
    shift
    # A contracted command is checked against its contract before pwsh starts (ADR-REPO-CMDCONTRACT#5); any other passes as written.
    _catzc_rows="$(_catzc_contract "$_catzc_text")"
    if [ -n "$_catzc_rows" ]; then
        _catzc_text="$(_catzc_checked "$_catzc_text" "$_catzc_rows" "$@")" || return 2
    else
        for _catzc_argument in "$@"; do
            case "$_catzc_argument" in
                -*) _catzc_text="$_catzc_text $_catzc_argument" ;;
                *) _catzc_text="$_catzc_text $(_catzc_literal "$_catzc_argument")" ;;
            esac
        done
    fi
    "$_catzc_pwsh" -NoProfile -NonInteractive -Command "$_catzc_load; $_catzc_text"
}

# The lookup rows of one command, from the generated importer-commands.sh beside this file; empty for an uncontracted command.
_catzc_contract() {
    _catzc_commands=''
    _catzc_lookup="${CATZC_COMMAND_LOOKUP:-$_catzc_root/importer-commands.sh}"
    if [ -f "$_catzc_lookup" ]; then
        # shellcheck source=/dev/null
        . "$_catzc_lookup"
    fi
    printf '%s\n' "$_catzc_commands" | awk -F '\t' -v command="$1" '$1 == command'
}

# The call text of a contracted command: each -Name is a parameter the contract names, a switch takes no value, an int value is a
# whole number and passes unquoted, a bool passes as $true or $false, and every mandatory parameter is present unless a value is
# passed by position. A violation prints the contract's asset and fails.
_catzc_checked() {
    _catzc_command="$1"
    _catzc_call="$1"
    _catzc_table="$2"
    shift 2
    _catzc_asset="$(printf '%s\n' "$_catzc_table" | awk -F '\t' 'NR == 1 { print $7 }')"
    _catzc_seen=' '
    _catzc_positional=0
    while [ "$#" -gt 0 ]; do
        _catzc_argument="$1"
        shift
        case "$_catzc_argument" in
            -*)
                _catzc_name="${_catzc_argument#-}"
                _catzc_row="$(printf '%s\n' "$_catzc_table" | awk -F '\t' -v name="$_catzc_name" '$2 != "" && tolower($2) == tolower(name)')"
                if [ -z "$_catzc_row" ]; then
                    echo "cats: $_catzc_command has no parameter -$_catzc_name ($_catzc_asset)" >&2
                    return 2
                fi
                _catzc_type="$(printf '%s\n' "$_catzc_row" | awk -F '\t' '{ print $3 }')"
                _catzc_lower="$(printf '%s' "$_catzc_name" | tr '[:upper:]' '[:lower:]')"
                _catzc_seen="$_catzc_seen$_catzc_lower "
                if [ "$_catzc_type" = 'switch' ]; then
                    _catzc_call="$_catzc_call -$_catzc_name"
                    continue
                fi
                if [ "$#" -eq 0 ]; then
                    echo "cats: $_catzc_command: -$_catzc_name takes a $_catzc_type value ($_catzc_asset)" >&2
                    return 2
                fi
                _catzc_value="$1"
                shift
                case "$_catzc_type" in
                    int)
                        case "$_catzc_value" in
                            '' | *[!0-9-]* | ?*-*)
                                echo "cats: $_catzc_command: -$_catzc_name takes an int, not '$_catzc_value' ($_catzc_asset)" >&2
                                return 2
                                ;;
                        esac
                        _catzc_call="$_catzc_call -$_catzc_name $_catzc_value"
                        ;;
                    bool)
                        case "$_catzc_value" in
                            true | True | 1) _catzc_call="$_catzc_call -$_catzc_name:\$true" ;;
                            false | False | 0) _catzc_call="$_catzc_call -$_catzc_name:\$false" ;;
                            *)
                                echo "cats: $_catzc_command: -$_catzc_name takes true or false, not '$_catzc_value' ($_catzc_asset)" >&2
                                return 2
                                ;;
                        esac
                        ;;
                    *) _catzc_call="$_catzc_call -$_catzc_name $(_catzc_literal "$_catzc_value")" ;;
                esac
                ;;
            *)
                _catzc_positional=1
                _catzc_call="$_catzc_call $(_catzc_literal "$_catzc_argument")"
                ;;
        esac
    done
    if [ "$_catzc_positional" -eq 0 ]; then
        _catzc_missing="$(printf '%s\n' "$_catzc_table" | awk -F '\t' -v seen="$_catzc_seen" '$5 == "1" && $6 != "1" && index(seen, " " tolower($2) " ") == 0 { print $2; exit }')"
        if [ -n "$_catzc_missing" ]; then
            echo "cats: $_catzc_command needs -$_catzc_missing ($_catzc_asset)" >&2
            return 2
        fi
    fi
    printf '%s' "$_catzc_call"
}
