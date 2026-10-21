# ---
# catzc:
#   immutable:
#     with_body_sha: "6abd53f57de4"
# ---

"""Black-box contract drift test of Catzc.Base.Repository's provided command Get-RepositoryFile.

The caller below calls the command the way an outside consumer does. It takes the call shape from the command contract,
read through the one reader, Get-CommandContract (ADR-REPO-CMDCONTRACT-ONEREADER), as the contract's one-line signature,
never by parsing the asset itself. When the asset changes and this caller does not, the shape check fails before any call
is made. The contract is read from CATZC_REPOSITORY_ROOT, so pointing it at a copy with one edited asset proves the test
fails.
"""

import json
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import PurePath

import pytest

COMMAND = "Get-RepositoryFile"
MODULE = "Catzc.Base.Repository"
# What this caller passes and what it reads back; it changes only when the caller does.
CALLER_ARGUMENTS = {"Path": "README.md"}
CALLER_OUTPUT = "string"
ANSI = re.compile(r"\x1b\[[0-9;]*m")
POWERSHELL_ENGINE = "pwsh"


@dataclass(frozen=True)
class Parameter:
    """One parameter of a contract signature, as the contract language states it."""

    name: str
    type: str
    is_list: bool
    mandatory: bool


@dataclass(frozen=True)
class Signature:
    """A command contract's signature: its parameters in contract order and its output type."""

    parameters: tuple[Parameter, ...]
    output: str


def require_env(name: str) -> str:
    """Return an environment variable the test contract names, failing the test when it is not set."""
    value = os.environ.get(name, "")
    if not value:
        pytest.fail(f"{name} is not set; run the Python tests through Invoke-PythonTest")
    return value


def run_engine(command: str) -> str:
    """Start the engine the contract names with its entry loaded, run the command, and return what it printed, trimmed."""
    executable = require_env("CATZC_ENGINE_EXECUTABLE")
    start = json.loads(require_env("CATZC_ENGINE_START"))
    if not isinstance(start, list) or not start:
        pytest.fail("CATZC_ENGINE_START is not a JSON array of arguments")
    arguments = list(start)
    arguments[-1] = arguments[-1].replace("{command}", command, 1)
    # Bounds one engine start, an import plus one command, by the contract's engine start limit.
    timeout = int(require_env("CATZC_ENGINE_TIMEOUT_SECONDS"))
    completed = subprocess.run([executable, *arguments], capture_output=True, text=True, timeout=timeout, check=False)
    if completed.returncode != 0:
        pytest.fail(f"the engine failed to run {command!r} with exit {completed.returncode}:\n{completed.stdout}{completed.stderr}")
    return ANSI.sub("", completed.stdout).strip()


def expression(text: str) -> str:
    """The command text for a PowerShell expression: as written under pwsh, single-quoted as one argument under a POSIX engine's cats."""
    if require_env("CATZC_ENGINE") == POWERSHELL_ENGINE:
        return text
    return "'" + text.replace("'", "'\\''") + "'"


def parse_signature(text: str) -> Signature:
    """Read a contract signature line, 'Name: spec, Name: spec[; default set X][ -> Output]', into its parameters and output."""
    body, _, output = text.partition(" -> ")
    body = body.split("; default set ", 1)[0]
    parameters: list[Parameter] = []
    if body != "no parameters":
        for part in body.split(", "):
            name, _, spec = part.partition(": ")
            type_text = spec.split(" ", 1)[0]
            mandatory = type_text.endswith("!")
            type_text = type_text.rstrip("!")
            is_list = type_text.endswith("[]")
            parameters.append(Parameter(name, type_text.removesuffix("[]"), is_list, mandatory))
    return Signature(tuple(parameters), output or "void")


def drift(signature: Signature, arguments: dict[str, str], output: str) -> list[str]:
    """Every way the caller's call no longer fits the contract: an unknown, missing or mistyped parameter, or another output."""
    findings: list[str] = []
    by_name = {parameter.name: parameter for parameter in signature.parameters}
    for name in arguments:
        parameter = by_name.get(name)
        if parameter is None:
            findings.append(f"the caller passes -{name}, which the contract does not name")
        elif parameter.type != "string" or parameter.is_list:
            findings.append(f"the caller passes -{name} one string, but the contract types it {parameter.type}{'[]' if parameter.is_list else ''}")
    for parameter in signature.parameters:
        if parameter.mandatory and parameter.name not in arguments:
            findings.append(f"the contract makes -{parameter.name} mandatory, but the caller does not pass it")
    if signature.output != output:
        findings.append(f"the caller reads {output}, but the contract returns {signature.output}")
    return findings


def read_signature() -> Signature:
    """Read the command's contract signature from the contracts under CATZC_REPOSITORY_ROOT, through the one reader."""
    root = require_env("CATZC_REPOSITORY_ROOT").replace("\\", "/")
    text = run_engine(expression(f"(Get-CommandContract -Name {COMMAND} -Module {MODULE} -RepositoryRoot {root}).Signature"))
    if not text:
        pytest.fail(f"no command contract names {MODULE}/{COMMAND} under {root}/contracts")
    return parse_signature(text)


def normalize_path(path: str) -> str:
    """Make two spellings of one file compare equal: forward slashes, and on Windows no case difference."""
    normalized = PurePath(path).as_posix()
    return normalized.lower() if sys.platform == "win32" else normalized


def test_contract_drift() -> None:
    """The caller's call fits Get-RepositoryFile's contract, and the call built from the contract returns the file's path."""
    signature = read_signature()
    findings = drift(signature, CALLER_ARGUMENTS, CALLER_OUTPUT)
    assert not findings, f"{COMMAND}'s contract changed and this caller did not:\n" + "\n".join(findings)
    call = " ".join([COMMAND, *(f"-{p.name} {CALLER_ARGUMENTS[p.name]}" for p in signature.parameters if p.name in CALLER_ARGUMENTS)])
    got = run_engine(call)
    want = f"{require_env('CATZC_REPOSITORY_ROOT')}/{CALLER_ARGUMENTS['Path']}"
    assert normalize_path(got) == normalize_path(want), f"{call} printed {got!r}, want {want!r}"


def test_drift_names_each_mismatch() -> None:
    """An edited signature is reported once per mismatch: a renamed parameter, a new mandatory one, another output."""
    edited = parse_signature("File: string!, Kind: string! -> string[]")
    assert drift(edited, CALLER_ARGUMENTS, CALLER_OUTPUT) == [
        "the caller passes -Path, which the contract does not name",
        "the contract makes -File mandatory, but the caller does not pass it",
        "the contract makes -Kind mandatory, but the caller does not pass it",
        "the caller reads string, but the contract returns string[]",
    ]
