---
name: cost-audit
description: >
  Audit what a Claude session cost and why against the session-cost plan's levers, and propose each change for the user to decide; writes
  only to out/ and the plan's lever-status lines; input is a pasted cost summary, or none.
user-invocable: false
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: []
---

# cost-audit

Measure, report and propose; never change a rule you measure. Plain `wc`, `grep`, `find` and the Read tools answer everything; no import.

1. With a pasted summary: split each model's input, output, cache read and cache write tokens using the usual ratios to the input price
   (cache read 0.1x, 5-minute write 1.25x, 1-hour write 2x, output 5x; the summary's prompt-cache line says which TTL); report each bucket's
   share as a ratio estimate, never a price you did not read this session. Without a summary, skip this step.
2. Measure the context inputs: the ADR-reading line of `.claude/CLAUDE.md` quoted with its line number; bytes and file counts under
   `docs/drs/` (all, `research/`, the five largest files) and of `docs/drs/index.md`; the `.claude` weight as debt-reduce step 2 says.
3. Count the denials in `out/time-safeguard.log` by command shape (importer call, Pester run, background call without a prefix, other) with
   the top repeats; an absent log is said.
4. For each lever of the plan: `done`, `open`, `regressed` with the evidence, or `not measurable from the tree`; a missing plan is said and
   the levers above stand in.
5. For each open or regressed lever write the exact change (file, current text, replacement) into `out/session-cost-<yyyy-MM-dd>.md` (a
   numbered suffix when it exists); update only the lever-status lines of the plan, nothing else anywhere.
6. Report, then one block: Report path; Cost shares; Context numbers; Denials; Levers; Proposed count, for the user to decide.
