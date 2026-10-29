"""One engine start answers every command the Catzc.Base.Repository tests read (ADR-AUTO-TEST-ONEIMPORTPERCASE).

An engine start is an import plus a command, the cost of the whole folder under each of the three engines, so the start runs
once per test run with the commands chained and a marker line between their outputs; the tests read the answers by name."""

import json
import os
import re
import subprocess

import pytest

ANSI = re.compile(r"\x1b\[[0-9;]*m")
POWERSHELL_ENGINE = "pwsh"
MARKER = "@@catzc-answer-end@@"

# The command contract the drift test reads, and the call its caller makes; the drift test checks the call it builds from the
# contract against this one and starts the engine again only when they differ.
CONTRACT = "get_repository_file"
GROUP = "pwsh.base.repository"
FILE_CALL = "Get-RepositoryFile -path README.md"


def require_env(name: str) -> str:
    """Return an environment variable the test contract names, failing the test when it is not set."""
    value = os.environ.get(name, "")
    if not value:
        pytest.fail(f"{name} is not set; run the Python tests through Invoke-PythonTest")
    return value


def expression(text: str) -> str:
    """The command text for a PowerShell expression: as written under pwsh, single-quoted as one argument under a POSIX engine's cats."""
    if require_env("CATZC_ENGINE") == POWERSHELL_ENGINE:
        return text
    return "'" + text.replace("'", "'\\''") + "'"


def run_engine(command: str) -> str:
    """Start the engine the contract names with its entry loaded, run the command, and return what it printed, trimmed."""
    executable = require_env("CATZC_ENGINE_EXECUTABLE")
    start = json.loads(require_env("CATZC_ENGINE_START"))
    if not isinstance(start, list) or not start:
        pytest.fail("CATZC_ENGINE_START is not a JSON array of arguments")
    arguments = list(start)
    arguments[-1] = arguments[-1].replace("{command}", command, 1)
    # Bounds one engine start, an import plus its commands, by the contract's engine start limit.
    timeout = int(require_env("CATZC_ENGINE_TIMEOUT_SECONDS"))
    completed = subprocess.run([executable, *arguments], capture_output=True, text=True, timeout=timeout, check=False)
    if completed.returncode != 0:
        pytest.fail(f"the engine failed to run {command!r} with exit {completed.returncode}:\n{completed.stdout}{completed.stderr}")
    return ANSI.sub("", completed.stdout).strip()


@pytest.fixture(scope="session")
def engine_answers() -> dict[str, str]:
    """What the one engine start printed for the repository root, the contract's signature and the caller's file call."""
    root = require_env("CATZC_REPOSITORY_ROOT").replace("\\", "/")
    signature = expression(f"(Get-CommandContract -Name {CONTRACT} -Module {GROUP} -RepositoryRoot {root}).Signature")
    if require_env("CATZC_ENGINE") == POWERSHELL_ENGINE:
        chain = f"Get-RepositoryRoot; '{MARKER}'; {signature}; '{MARKER}'; {FILE_CALL}"
    else:
        chain = f"Get-RepositoryRoot; echo {MARKER}; cats {signature}; echo {MARKER}; cats {FILE_CALL}"
    parts = [part.strip() for part in run_engine(chain).split(MARKER)]
    if len(parts) != 3:
        pytest.fail(f"the engine start printed {len(parts)} answers, want 3:\n{chain}")
    return {"root": parts[0], "signature": parts[1], "file": parts[2], "file_call": FILE_CALL}
