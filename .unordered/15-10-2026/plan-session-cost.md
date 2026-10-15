# Plan: cut Claude session cost

## The numbers (one session, $21.71, 1 h wall)

| Bucket          | Tokens | Relative weight¹ | Share of cost¹ |
| --------------- | -----: | ---------------: | -------------: |
| Cache read      | 32.3 M |      × 0.1 input |      **~39 %** |
| Cache write, 1h |  1.6 M |      × 2.0 input |      **~39 %** |
| Output          |  329 k |      × 5.0 input |          ~20 % |
| Uncached input  |  103 k |      × 1.0 input |           ~1 % |

¹ Estimated with Anthropic's usual price ratios: cache read 0.1×, 1-hour cache write 2×, output 5× the input price. I did not look up the
actual Opus 5.5 prices, so treat the shares as rough, not as a bill.

**Most of the cost is context size, not the work itself.** Every request re-reads the whole cached context. Every fresh context (a new
subagent, a compaction, an expired cache) pays the 2× write again. Output, which is the actual work (2,140 lines added), is about a fifth.

## Levers, biggest first

Lever 1 (read `docs/adr/index.md`, not every ADR) is done. `session-cost-audit` and `write-drawio-files` already run on `model: sonnet`.

### 2. Spawn fewer, better-briefed subagents

- Each subagent starts cold: it pays a fresh cache write and re-reads the files it needs.
- **Change:** do inline any task the main session can finish in a few tool calls. When delegating, the `catzc-worker` brief names the exact
  files and rule codes, so the worker doesn't sweep the ADRs. Parallel waves (drawio, up to 12 makers) cost about one context per maker. Cap
  the wave size at what you will actually review.

### 3. Keep cross-session chatter targeted

- In this session, three `catzc-02` broadcasts produced three full turns and no edits. Each turn re-reads the whole context.
- **Change:** a session sends a heads-up only to the sessions that own dirty files on its list. Rule-change notices go in CLAUDE.md or
  memory, which every session reads anyway, not in a broadcast. A recipient with nothing to do answers in one line.

### 4. Cut output tokens

- Change files with Edit, not by rewriting them with Write. Don't re-print tables or file contents in chat. Keep end-of-task reports to what
  changed and what's open.
- Plans and docs: write them once, then edit. A full regeneration costs the whole file in output again.

### 5. Stop timeout churn

- With a 3 s foreground limit, any call that imports catzc gets denied and retried, and each retry is a full turn. Send import, Pester and
  gate calls straight to the background with a `timeout <s>` prefix. Probe with plain bash or Read/Grep, which the CLAUDE.md § Time
  safeguard already requires. Check `out/time-safeguard.log` for repeat offenders and give them a `timeouts.yml` entry or a script in
  `out/`.

### 6. Session hygiene

- Start a new session for each unrelated task instead of one long-running session. Context grows with every turn, and each turn re-pays it
  as cache reads. Run `/compact` before pivoting within a session.
- Use a smaller model (`/model`, or `model:` in an agent's frontmatter) for mechanical subagents: link sweeps, print-artifacts, label edits
  in drawio files.

## Order of work

1. Add a "brief names files and rule codes" line to `.claude/agents/catzc-worker.md`, and a model choice to the mechanical agents.
2. Agree on the cross-session etiquette (lever 3) and record it in CLAUDE.md.
3. Compare the next session's cost summary with this one.
