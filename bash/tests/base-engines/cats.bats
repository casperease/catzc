# Black-box tests of the bash engine's entry, importer.sh, and its cats dispatcher (Catzc.Base.Engines).
#
# Each test uses importer.sh the way a Bash user does (ADR-AUTO-TESTLANG-BLACKBOX): setup sources the engine's entry
# (CATZC_ENGINE_ENTRY), and a test runs a catzc command through cats, asserting on output and exit code only. Three of
# them start pwsh and import catzc: setup_file starts those three cats calls at once and saves each one's exit code and
# output, and each test asserts on its own saved call (ADR-AUTO-TEST-ONEIMPORTPERCASE); the list case starts pwsh on a
# stand-in entry, and the run-directly case and the contract refusals start no pwsh.

_cats_source_entry() {
    if [ -z "${CATZC_ENGINE_ENTRY:-}" ]; then
        echo "CATZC_ENGINE_ENTRY is not set; run the Bash tests through Invoke-BashTest" >&2
        return 1
    fi
    # shellcheck source=/dev/null
    source "$CATZC_ENGINE_ENTRY"
}

# One cats call, its exit code and output saved under a name for the test that asserts on it.
_cats_save() {
    local name="$1" code=0
    shift
    # bats runs setup_file under errexit, so a failing call is caught here and its code saved.
    cats "$@" >"$BATS_FILE_TMPDIR/$name.out" 2>&1 || code=$?
    echo "$code" >"$BATS_FILE_TMPDIR/$name.status"
}

# The saved call as bats' run leaves it: status and output, trailing newlines trimmed.
_cats_saved() {
    status="$(cat "$BATS_FILE_TMPDIR/$1.status")"
    output="$(cat "$BATS_FILE_TMPDIR/$1.out")"
}

setup_file() {
    _cats_source_entry || return 1
    _cats_save guid Test-IsGuid -ObjectGuid "it's not a guid" &
    _cats_save unknown Get-NoSuchWidget &
    (
        _cats_fixture_lookup "$BATS_FILE_TMPDIR"
        _cats_save kebab test-is-guid --object-guid "it's not a guid"
    ) &
    wait
}

setup() {
    _cats_source_entry
}

@test "importer.sh run instead of sourced exits 1 and says to source it" {
    run bash "$CATZC_ENGINE_ENTRY"
    [ "$status" -eq 1 ] || {
        echo "running importer.sh exited $status, want 1: $output" >&2
        return 1
    }
    [[ "$output" == *"must be sourced, not run"* ]] || {
        echo "running importer.sh printed '$output', want it to say it must be sourced" >&2
        return 1
    }
}

@test "a parameter name passes through and a value with a space and a quote stays one value" {
    _cats_saved guid
    [ "$status" -eq 0 ] || {
        echo "cats Test-IsGuid failed with exit $status: $output" >&2
        return 1
    }
    local got
    got="$(printf '%s' "$output" | tr -d '\r' | tail -n 1)"
    [ "$got" = "False" ] || {
        echo "cats Test-IsGuid -ObjectGuid \"it's not a guid\" printed '$got', want 'False'" >&2
        return 1
    }
}

@test "an unknown command fails and names the command" {
    _cats_saved unknown
    [ "$status" -ne 0 ] || {
        echo "cats Get-NoSuchWidget exited 0, want a failure: $output" >&2
        return 1
    }
    [[ "$output" == *"Get-NoSuchWidget"* ]] || {
        echo "cats Get-NoSuchWidget printed '$output', want it to name the command" >&2
        return 1
    }
}

# A neutral lookup for the contract checks: each case fails before pwsh starts. It lands in the folder named, else the test's own.
_cats_fixture_lookup() {
    CATZC_COMMAND_LOOKUP="${1:-$BATS_TEST_TMPDIR}/importer-commands.sh"
    export CATZC_COMMAND_LOOKUP
    {
        printf "_catzc_commands='\n"
        # command, parameter (normal form), type, list, mandatory, pipeline, asset, sets, default set, then kebab and pwsh renderings
        printf 'get_widget\tcount\tint\t0\t1\t0\tcontracts/catzc/0.1.0/catzc.widget/get_widget.command.yml\t\t\tget-widget\tcount\tGet-Widget\tCount\n'
        printf 'get_widget\tloud\tswitch\t0\t0\t0\tcontracts/catzc/0.1.0/catzc.widget/get_widget.command.yml\t\t\tget-widget\tloud\tGet-Widget\tLoud\n'
        printf 'find_gadget\tid\tstring\t0\t1\t0\tcontracts/catzc/0.1.0/catzc.widget/find_gadget.command.yml\tid\tall\tfind-gadget\tid\tFind-Gadget\tId\n'
        printf 'find_gadget\tcount\tint\t0\t1\t0\tcontracts/catzc/0.1.0/catzc.widget/find_gadget.command.yml\trandom\tall\tfind-gadget\tcount\tFind-Gadget\tCount\n'
        printf 'find_gadget\tseed\tint\t0\t0\t0\tcontracts/catzc/0.1.0/catzc.widget/find_gadget.command.yml\trandom\tall\tfind-gadget\tseed\tFind-Gadget\tSeed\n'
        printf 'test_is_guid\tobject_guid\tstring\t0\t1\t0\tcontracts/catzc/0.1.0/catzc.widget/test_is_guid.command.yml\t\t\ttest-is-guid\tobject-guid\tTest-IsGuid\tObjectGuid\n'
        printf 'join_widget\tname\tstring\t1\t1\t0\tcontracts/catzc/0.1.0/catzc.widget/join_widget.command.yml\t\t\tjoin-widget\tname\tJoin-Widget\tName\n'
        printf "'\n"
    } >"$CATZC_COMMAND_LOOKUP"
}

@test "a contracted command named in kebab case reaches pwsh by its pwsh names" {
    _cats_saved kebab
    [ "$status" -eq 0 ] || {
        echo "cats test-is-guid failed with exit $status: $output" >&2
        return 1
    }
    local got
    got="$(printf '%s' "$output" | tr -d '\r' | tail -n 1)"
    [ "$got" = "False" ] || {
        echo "cats test-is-guid --object-guid \"it's not a guid\" printed '$got', want 'False'" >&2
        return 1
    }
}

@test "a contracted command refuses a parameter not in kebab case" {
    _cats_fixture_lookup
    run cats get-widget -Count 3
    [ "$status" -eq 2 ] || {
        echo "cats get-widget -Count exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"takes its parameters in kebab case, as --name"*"get_widget.command.yml"* ]] || {
        echo "cats get-widget -Count printed '$output', want the kebab refusal and the asset named" >&2
        return 1
    }
}

@test "a contracted command refuses parameters from two parameter sets" {
    _cats_fixture_lookup
    run cats find-gadget --id one --count 2
    [ "$status" -eq 2 ] || {
        echo "cats find-gadget --id --count exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"belong to no one parameter set"*"find_gadget.command.yml"* ]] || {
        echo "cats find-gadget --id --count printed '$output', want the set refusal and the asset named" >&2
        return 1
    }
}

@test "a contracted command refuses a call missing a mandatory parameter of the set it fits" {
    _cats_fixture_lookup
    run cats find-gadget --seed 7
    [ "$status" -eq 2 ] || {
        echo "cats find-gadget --seed exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"needs --count"* ]] || {
        echo "cats find-gadget --seed printed '$output', want it to name --count" >&2
        return 1
    }
}

@test "a contracted command refuses a parameter its contract does not name, naming the asset" {
    _cats_fixture_lookup
    run cats get-widget --count 3 --gadget x
    [ "$status" -eq 2 ] || {
        echo "cats get-widget --gadget exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"has no parameter --gadget"*"get_widget.command.yml"* ]] || {
        echo "cats get-widget --gadget printed '$output', want the parameter and the asset named" >&2
        return 1
    }
}

@test "a contracted command refuses a call without a mandatory parameter" {
    _cats_fixture_lookup
    run cats get-widget --loud
    [ "$status" -eq 2 ] || {
        echo "cats get-widget --loud exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"needs --count"* ]] || {
        echo "cats get-widget --loud printed '$output', want it to name --count" >&2
        return 1
    }
}

@test "a contracted int parameter refuses a value that is not a whole number" {
    _cats_fixture_lookup
    run cats get-widget --count three
    [ "$status" -eq 2 ] || {
        echo "cats get-widget --count three exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"--count takes an int, not 'three'"* ]] || {
        echo "cats get-widget --count three printed '$output', want the int refusal" >&2
        return 1
    }
}

@test "a contracted list parameter repeats its name and reaches pwsh as one array" {
    _cats_fixture_lookup
    # A stand-in entry that defines the one command, so the call reaches pwsh without importing catzc.
    local entry="$BATS_TEST_TMPDIR/widget-importer.ps1"
    # The quoted text is PowerShell source, written as it stands; bash expands nothing in it.
    # shellcheck disable=SC2016
    printf '%s\n' 'function Join-Widget { param([string[]] $Name) "$($Name.Count):$($Name -join "|")" }' >"$entry"
    # pwsh reads the path in its own form (C:/... under Git Bash on Windows), as importer.sh does for its root.
    if command -v cygpath >/dev/null 2>&1; then
        entry="$(cygpath -m "$entry")"
    fi
    CATZC_IMPORTER="$entry"
    export CATZC_IMPORTER
    run cats join-widget --name gadget --name "it's a sprocket"
    [ "$status" -eq 0 ] || {
        echo "cats join-widget failed with exit $status: $output" >&2
        return 1
    }
    local got
    got="$(printf '%s' "$output" | tr -d '\r' | tail -n 1)"
    [ "$got" = "2:gadget|it's a sprocket" ] || {
        echo "cats join-widget --name gadget --name \"it's a sprocket\" printed '$got', want '2:gadget|it's a sprocket'" >&2
        return 1
    }
}
