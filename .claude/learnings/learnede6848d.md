# Session learnings e6848d

Started 2026-10-22T04:07:45.5039640+02:00.

- 2026-10-22 Cats: In hindsight I wish I knew this fact: the diagram kit wrote CRLF on Windows (Path.write_text text mode) until
  declaration.py wrote LF.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: the drain limit is wait.drain_seconds on TimeoutsConfig.cs, default 5 declared once
  on the type, with no timeouts.yml line.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: batching plan edits into one Format-Code + Test-Plans run after workers go quiet,
  instead of one run per strike.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: asking a burst owner for burst done before queueing a run, instead of rerunning
  after run lock busy.
