// Black-box tests of Catzc.Base.Repository: each test starts the engine as its own pwsh process, loaded through
// the script named by CATZC_ENGINE_ENTRY (the repository's importer.ps1 in a source run, the build's
// Import-Catzc.ps1 in a build run), and asserts on what the engine prints. Invoke-GoTest sets CATZC_ENGINE_ENTRY
// and CATZC_REPOSITORY_ROOT for the go commands it runs.
package repository

import (
	"context"
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

// runEngine starts pwsh, loads the engine through the entry script with its output discarded, runs the command,
// and returns what the command printed, trimmed.
func runEngine(t *testing.T, command string) string {
	t.Helper()
	entry := requireEnv(t, "CATZC_ENGINE_ENTRY")
	pwsh, err := exec.LookPath("pwsh")
	if err != nil {
		t.Fatalf("pwsh is not on PATH: %v", err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), engineTimeout)
	defer cancel()
	script := ". '" + strings.ReplaceAll(entry, "'", "''") + "' *> $null; " + command
	output, err := exec.CommandContext(ctx, pwsh, "-NoProfile", "-Command", script).CombinedOutput()
	if err != nil {
		t.Fatalf("pwsh -Command %q failed: %v\n%s", command, err, output)
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
