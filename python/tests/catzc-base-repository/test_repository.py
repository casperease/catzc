"""Black-box tests of Catzc.Base.Repository.

Each test starts the engine as its own pwsh process, loaded through the script named by CATZC_ENGINE_ENTRY (the
repository's importer.ps1 in a source run, the build's Import-Catzc.ps1 in a build run), and asserts on what the
engine prints. Invoke-PythonTest sets CATZC_ENGINE_ENTRY and CATZC_REPOSITORY_ROOT for the uv commands it runs.
"""

import os
import shutil
import subprocess
import sys
from pathlib import PurePath

import pytest

# Bounds one engine start: an import plus one command.
ENGINE_TIMEOUT_SECONDS = 300


def require_env(name: str) -> str:
    """Return an environment variable the test contract names, failing the test when it is not set."""
    value = os.environ.get(name, "")
    if not value:
        pytest.fail(f"{name} is not set; run the Python tests through Invoke-PythonTest")
    return value


def run_engine(command: str) -> str:
    """Start pwsh, load the engine through the entry script with its output discarded, run the command, and return
    what the command printed, trimmed."""
    entry = require_env("CATZC_ENGINE_ENTRY")
    pwsh = shutil.which("pwsh")
    if pwsh is None:
        pytest.fail("pwsh is not on PATH")
    script = ". '" + entry.replace("'", "''") + "' *> $null; " + command
    completed = subprocess.run(
        [pwsh, "-NoProfile", "-Command", script],
        capture_output=True,
        text=True,
        timeout=ENGINE_TIMEOUT_SECONDS,
        check=False,
    )
    if completed.returncode != 0:
        pytest.fail(f"pwsh -Command {command!r} failed with exit {completed.returncode}:\n{completed.stdout}{completed.stderr}")
    return completed.stdout.strip()


def normalize_path(path: str) -> str:
    """Make two spellings of one folder compare equal: forward slashes, no trailing slash, and on Windows no case
    difference."""
    normalized = PurePath(path).as_posix().rstrip("/")
    if sys.platform == "win32":
        normalized = normalized.lower()
    return normalized


def assert_repository_root() -> None:
    """Check that the engine reports the repository root the test contract names."""
    want = require_env("CATZC_REPOSITORY_ROOT")
    got = run_engine("Get-RepositoryRoot")
    assert normalize_path(got) == normalize_path(want), f"Get-RepositoryRoot printed {got!r}, want {want!r}"


def test_repository_root() -> None:
    """The engine, started from its entry script, reports the repository root."""
    assert_repository_root()


def test_integrity_repository_root() -> None:
    """The same check as an integrity test, so it also runs against the build in the build run."""
    assert_repository_root()
