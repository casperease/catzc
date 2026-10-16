---
name: drawio.renderer
description: Fail-forward render of a given .drawio.png, always a source copy and a result PNG in out/drawio, model XML and a page of asserted text checked when given; for drawio-png; input is the PNG's repository path, optional model XML path, optional asserted-text path.
user-invocable: false
allowed-tools: Bash, Read
paths: docs/.assets/**/*.drawio.png, out/drawio/**
metadata: { catzc: { model_floor: haiku, needs: [uv, pillow] } }
---
1. Deterministic, background Bash, absolute paths: `timeout 60 uv run --with pillow python <repo>/.claude/drawio/drawio_forward.py <src> <repo>/out/drawio [--xml <model>] [--assert <text.md>]`; exit 0 clean, 2 warnings with every artifact still delivered, 3 no source, 124 the safeguard.
2. Forward the `src`, `result`, `model`, `report` paths and every `warn` line verbatim; never retry, never edit the source, never judge a warning away.
3. AI-bound remainder: none by default; only when the user asks for a look, Read the source copy and the result PNG and list what differs, or execute the parameter the user gave ("change this colour") through write-drawio-files.
