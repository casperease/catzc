# ---
# catzc:
#   derived:
#     path: bash/tests/catzc-base-engines/cats.bats
#     folder: tests/catzc-base-engines
#     name: cats
#     filetype: bats
#     kind: test
#     language: bash
#     track: bash
#     module: bash
#     moduletype: bash
# ---

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
