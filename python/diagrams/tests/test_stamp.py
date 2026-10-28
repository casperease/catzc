"""The kit's stamp: one run of the entry script stamps every file a writer wrote through Set-GeneratedFileHead, and a refusal stops."""

import subprocess

import pytest
from catzc.diagrams import stamp
from catzc.diagrams.module_paths import REPO


def test_one_call_carries_one_set_generated_file_head_line_per_path():
    widget, gadget = REPO / "out" / "widget.png", REPO / "out" / "gadget's.png"
    call = stamp.command([widget, gadget], "widget writer")
    assert call[:4] == ["pwsh", "-NoProfile", "-File", str(stamp.ENTRY)]
    assert call[4:] == [
        "Set-GeneratedFileHead -Path 'out/widget.png' -Writer 'widget writer'",
        "Set-GeneratedFileHead -Path 'out/gadget''s.png' -Writer 'widget writer'",
    ]


def test_a_path_outside_the_repository_is_left_alone_and_nothing_runs(tmp_path, monkeypatch):
    monkeypatch.setattr(subprocess, "run", lambda *args, **kwargs: pytest.fail("no run expected"))
    assert stamp.stamp([tmp_path / "widget.png"], "widget writer") == []


def test_the_run_is_bounded_by_the_run_lock_budget(monkeypatch):
    seen = {}

    def run(call, **kwargs):
        seen.update(kwargs)
        return subprocess.CompletedProcess(call, 0, "", "")

    monkeypatch.setattr(subprocess, "run", run)
    widget = REPO / "out" / "widget.png"
    assert stamp.stamp([widget], "widget writer") == [widget]
    assert seen["timeout"] == stamp.budget_seconds() + stamp.EXIT_GRACE_SECONDS
    assert seen["cwd"] == REPO


def test_a_refused_stamp_stops_the_writer_naming_the_last_lines(monkeypatch):
    monkeypatch.setattr(subprocess, "run", lambda call, **kwargs: subprocess.CompletedProcess(call, 1, "line one\nFAIL widget", ""))
    with pytest.raises(SystemExit, match="refused the widget writer head of 1 file.*FAIL widget"):
        stamp.stamp([REPO / "out" / "widget.png"], "widget writer")
