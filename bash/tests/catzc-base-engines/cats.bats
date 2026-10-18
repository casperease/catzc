# Black-box tests of the bash engine's entry, importer.sh, and its cats dispatcher (Catzc.Base.Engines).
#
# Each test uses importer.sh the way a Bash user does (ADR-AUTO-BASH#3): setup sources the engine's entry
# (CATZC_ENGINE_ENTRY), and a test runs a catzc command through cats, asserting on output and exit code only. Two of
# them start pwsh and import catzc; the run-directly case starts no pwsh.

setup() {
    if [ -z "${CATZC_ENGINE_ENTRY:-}" ]; then
        echo "CATZC_ENGINE_ENTRY is not set; run the Bash tests through Invoke-BashTest" >&2
        return 1
    fi
    # shellcheck source=/dev/null
    source "$CATZC_ENGINE_ENTRY"
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
    run cats Test-IsGuid -ObjectGuid "it's not a guid"
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
    run cats Get-NoSuchWidget
    [ "$status" -ne 0 ] || {
        echo "cats Get-NoSuchWidget exited 0, want a failure: $output" >&2
        return 1
    }
    [[ "$output" == *"Get-NoSuchWidget"* ]] || {
        echo "cats Get-NoSuchWidget printed '$output', want it to name the command" >&2
        return 1
    }
}

# A neutral lookup for the contract checks: each case fails before pwsh starts.
_cats_fixture_lookup() {
    CATZC_COMMAND_LOOKUP="$BATS_TEST_TMPDIR/importer-commands.sh"
    export CATZC_COMMAND_LOOKUP
    {
        printf "_catzc_commands='\n"
        printf 'Get-Widget\tCount\tint\t0\t1\t0\tcontracts/widget/0.0.0/Catzc.Widget/Get-Widget.command.yml\n'
        printf 'Get-Widget\tLoud\tswitch\t0\t0\t0\tcontracts/widget/0.0.0/Catzc.Widget/Get-Widget.command.yml\n'
        printf 'Find-Gadget\tId\tstring\t0\t1\t0\tcontracts/widget/0.0.0/Catzc.Widget/Find-Gadget.command.yml\tId\tAll\n'
        printf 'Find-Gadget\tCount\tint\t0\t1\t0\tcontracts/widget/0.0.0/Catzc.Widget/Find-Gadget.command.yml\tRandom\tAll\n'
        printf 'Find-Gadget\tSeed\tint\t0\t0\t0\tcontracts/widget/0.0.0/Catzc.Widget/Find-Gadget.command.yml\tRandom\tAll\n'
        printf "'\n"
    } >"$CATZC_COMMAND_LOOKUP"
}

@test "a contracted command refuses parameters from two parameter sets" {
    _cats_fixture_lookup
    run cats Find-Gadget -Id one -Count 2
    [ "$status" -eq 2 ] || {
        echo "cats Find-Gadget -Id -Count exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"belong to no one parameter set"*"Find-Gadget.command.yml"* ]] || {
        echo "cats Find-Gadget -Id -Count printed '$output', want the set refusal and the asset named" >&2
        return 1
    }
}

@test "a contracted command refuses a call missing a mandatory parameter of the set it fits" {
    _cats_fixture_lookup
    run cats Find-Gadget -Seed 7
    [ "$status" -eq 2 ] || {
        echo "cats Find-Gadget -Seed exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"needs -Count"* ]] || {
        echo "cats Find-Gadget -Seed printed '$output', want it to name -Count" >&2
        return 1
    }
}

@test "a contracted command refuses a parameter its contract does not name, naming the asset" {
    _cats_fixture_lookup
    run cats Get-Widget -Count 3 -Gadget x
    [ "$status" -eq 2 ] || {
        echo "cats Get-Widget -Gadget exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"has no parameter -Gadget"*"Get-Widget.command.yml"* ]] || {
        echo "cats Get-Widget -Gadget printed '$output', want the parameter and the asset named" >&2
        return 1
    }
}

@test "a contracted command refuses a call without a mandatory parameter" {
    _cats_fixture_lookup
    run cats Get-Widget -Loud
    [ "$status" -eq 2 ] || {
        echo "cats Get-Widget -Loud exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"needs -Count"* ]] || {
        echo "cats Get-Widget -Loud printed '$output', want it to name -Count" >&2
        return 1
    }
}

@test "a contracted int parameter refuses a value that is not a whole number" {
    _cats_fixture_lookup
    run cats Get-Widget -Count three
    [ "$status" -eq 2 ] || {
        echo "cats Get-Widget -Count three exited $status, want 2: $output" >&2
        return 1
    }
    [[ "$output" == *"-Count takes an int, not 'three'"* ]] || {
        echo "cats Get-Widget -Count three printed '$output', want the int refusal" >&2
        return 1
    }
}
