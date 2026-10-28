"""The kit's stamp: one run of the entry script stamps every file a writer wrote through Set-GeneratedFileHead, and a refusal stops."""

import subprocess

import pytest
from catzc.diagrams import stamp
from catzc.diagrams.module_paths import REPO


def test_one_call_carries_one_line_per_writer_with_every_path_as_an_array():
    widget, gadget = REPO / "out" / "widget.png", REPO / "out" / "gadget's.png"
    (call,) = stamp.commands([widget, gadget], "widget writer")
    assert call[:4] == ["pwsh", "-NoProfile", "-File", str(stamp.ENTRY)]
    assert call[4:] == [
        "@('out/widget.png', 'out/gadget''s.png') | ForEach-Object { Set-GeneratedFileHead -Path $_ -Writer 'widget writer' }",
    ]


def test_four_hundred_paths_split_into_calls_under_the_limit_and_every_path_is_stamped():
    paths = [REPO / "out" / "diagrams" / f"widget-slide-{number:03}-of-the-gadget-series-{'x' * 40}.slide.png" for number in range(400)]
    calls = stamp.commands(paths, "widget writer")
    assert len(calls) > 1
    for call in calls:
        assert len(" ".join(call)) < 32767
        assert len(call) == 5
    stamped = [call[4] for call in calls]
    for path in paths:
        assert sum(f"'{path.relative_to(REPO).as_posix()}'" in line for line in stamped) == 1


def test_paths_that_fit_make_one_call():
    paths = [REPO / "out" / f"widget-{number}.png" for number in range(50)]
    assert len(stamp.commands(paths, "widget writer")) == 1


def test_a_split_run_runs_each_call_in_turn(monkeypatch):
    calls = []

    def run(call, **kwargs):
        calls.append(call)
        return subprocess.CompletedProcess(call, 0, "", "")

    monkeypatch.setattr(subprocess, "run", run)
    paths = [REPO / "out" / "diagrams" / f"widget-slide-{number:03}-of-the-gadget-series-{'x' * 40}.slide.png" for number in range(400)]
    assert stamp.stamp(paths, "widget writer") == paths
    assert calls == stamp.commands(paths, "widget writer")


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
