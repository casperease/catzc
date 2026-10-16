// ---
// catzc:
//   derived:
//     path: go/tests/catzc-base-repository/repository_test.go
//     kind: test
//     language: go
//     filekind: go
//     track: go
// ---

// Black-box tests of Catzc.Base.Repository: each test starts the engine as its own process the way the run's engine
// contract says — CATZC_ENGINE_EXECUTABLE, with the CATZC_ENGINE_START arguments, which load the run's entry (the
// repository's importer.ps1 in a source run, the build's Import-Catzc.ps1 in a build run) — and asserts on what the
// engine prints. Invoke-GoTest sets the contract and CATZC_REPOSITORY_ROOT for the go commands it runs.
package repository

import (
	"context"
	"encoding/json"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
	"time"
)

// engineTimeout bounds one engine start: an import plus one command.
const engineTimeout = 5 * time.Minute

// requireEnv returns the value of an environment variable the test contract names, failing the test when it is
// not set.
func requireEnv(t *testing.T, name string) string {
	t.Helper()
	value := os.Getenv(name)
	if value == "" {
		t.Fatalf("%s is not set; run the Go tests through Invoke-GoTest", name)
	}
	return value
}

// runEngine starts the engine the contract names, which loads the entry with its output discarded, runs the command,
// and returns what the command printed, trimmed.
func runEngine(t *testing.T, command string) string {
	t.Helper()
	executable := requireEnv(t, "CATZC_ENGINE_EXECUTABLE")
	var start []string
	if err := json.Unmarshal([]byte(requireEnv(t, "CATZC_ENGINE_START")), &start); err != nil || len(start) == 0 {
		t.Fatalf("CATZC_ENGINE_START is not a JSON array of arguments: %v", err)
	}
	arguments := append([]string(nil), start...)
	last := len(arguments) - 1
	arguments[last] = strings.Replace(arguments[last], "{command}", command, 1)
	ctx, cancel := context.WithTimeout(context.Background(), engineTimeout)
	defer cancel()
	output, err := exec.CommandContext(ctx, executable, arguments...).CombinedOutput()
	if err != nil {
		t.Fatalf("the engine failed to run %q: %v\n%s", command, err, output)
	}
	return strings.TrimSpace(string(output))
}

// normalizePath makes two spellings of one folder compare equal: forward slashes, no trailing slash, and on
// Windows no case difference.
func normalizePath(path string) string {
	normalized := strings.TrimRight(filepath.ToSlash(filepath.Clean(path)), "/")
	if runtime.GOOS == "windows" {
		normalized = strings.ToLower(normalized)
	}
	return normalized
}

// assertRepositoryRoot checks that the engine reports the repository root the test contract names.
func assertRepositoryRoot(t *testing.T) {
	t.Helper()
	want := requireEnv(t, "CATZC_REPOSITORY_ROOT")
	got := runEngine(t, "Get-RepositoryRoot")
	if normalizePath(got) != normalizePath(want) {
		t.Fatalf("Get-RepositoryRoot printed %q, want %q", got, want)
	}
}

// TestRepositoryRoot: the engine, started from its entry script, reports the repository root.
func TestRepositoryRoot(t *testing.T) {
	assertRepositoryRoot(t)
}

// TestIntegrityRepositoryRoot: the same check as an integrity test, so it also runs against the build in the
// build run.
func TestIntegrityRepositoryRoot(t *testing.T) {
	assertRepositoryRoot(t)
}
