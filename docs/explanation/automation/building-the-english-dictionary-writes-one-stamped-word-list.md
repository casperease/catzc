# Building the English dictionary writes one stamped word list

```text
A maintainer bumps the cspell pin; one command rebuilds the English half of the spelling oracle.

1  A maintainer bumps the cspell pin   the cause: the pinned cspell changed, so its dictionaries may have
2  build_english_dictionary                          the action: one command, in the contract form
3  The flattened English word list                   zone 1, local: get_repository_file shows assets/english.txt.gz
4  The stamp                                         zone 1, local: get_repository_file shows assets/english.stamp
5  The generated-files quality gate                          zone 2, local, after 4: test_generated_files sees no drift for the builder

Supports ADR-AUTO-SPELL, ADR-REPO-OUTDIR-COMPILEDPREBUILD and DDR-VISUAL-ACTIONISALENS (action lens).
```

The spelling quality gate judges every identifier fragment against two halves of one oracle: the curated terminology registry, and the
English word list of the pinned cspell. The English half is not read live from a package at check time; it is a committed, stamped artifact
that one command builds. This diagram is that command and what it leaves in the tree. The two files land together in the first zone; the
drift check in the second zone is what keeps them honest afterwards.

![Building the English dictionary writes one stamped word list][diagram]

[diagram]: .assets/building-the-english-dictionary-writes-one-stamped-word-list.drawio.png

## What the drawing shows

The [rendered action diagram](.assets/building-the-english-dictionary-writes-one-stamped-word-list.drawio.png) reads left to right. The
head, the circle fragment numbered 1 above the centre line on the left rim, holds the idea in bold, **A maintainer bumps the cspell pin**;
the stick man drawn over the drawing hangs from it, and his right hand rests on box 2, the statement `build_english_dictionary`, a call
without arguments, with `cats` at the hand and no line between head and hand. Two arcs cut the frame into zones. Zone 1 holds two notes
without chips, every effect being local: 3, the flattened word list written into the module's assets, and 4, the stamp with the versions it
was built from, each proven by `get_repository_file` on its path; the two edges out of the statement carry `executes` beside the line, one
climbing to 3 with its word above, one falling to 4 with its word below. Zone 2 holds one note, 5, the generated-files quality gate finding
list and stamp in step, proven by `test_generated_files` for the builder; its edge comes from 4, and its `effects` sits in a tight pill
where the line crosses the first arc. Under the frame the Proof box speaks the statement in each engine's words, and the legend band names
the kinds, the four operators, the marker and the transition pill, with the Proof box and the map key beside it.

## Notes from the inspection

- The proof line inside a note repeats a path the reader has to parse twice, once per note. The language could let a note name its
  observation and leave the full call to the proof block in the article, which the drawing already points at.
- Three notes leave most of the frame empty below the lane; the fixed height is by design, but a zone with one note could draw its arc
  shorter so the empty margin does not read as missing content.

### Stronger with new definitions

- `frame: { lane: compact }` at the diagram level, a named lane height beside the default, so a drawing with one note per zone draws a
  shorter frame and shorter arcs.

## Walkthrough

1. **A maintainer bumps the cspell pin.** The cause is a change to the pinned tool: a new cspell may ship new dictionaries, so the committed
   word list must be rebuilt from it.
2. **build_english_dictionary.** The action is one command in the contract form, with no arguments. It is an authoring step: it writes into
   the source module, never into an installed build
   ([ADR-REPO-OUTDIR-COMPILEDPREBUILD](../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-compiledprebuild)).
3. **The flattened English word list.** The first zone holds what the command writes directly. cspell's bundled English dictionaries are
   flattened into one compressed list, `assets/english.txt.gz`, and the observation that shows it is `get_repository_file` on that path.
4. **The stamp.** Beside the list, in the same zone and the same run of the command, a sidecar stamp records the cspell and dictionary
   versions the list was built from. The two files are one artifact in two parts, which is why they stand in one zone.
5. **The generated-files quality gate.** The second zone holds what the two files cause further out. The generated-files registry names the
   builder with its inputs and its outputs, and `test_generated_files` for that generator finds the outputs in step with the inputs: the
   gate that fails the moment someone bumps the pin without rebuilding ([ADR-AUTO-SPELL](../../drs/automation/spell-out-names.md)).

## The proof

The drawing never says what the proof does not run. The three runs below are copied from the accosted file the diagram names, and each
observation on the drawing occurs in them verbatim
([DDR-VISUAL-PROOFISTHEACCOSTEDFILE](../../drs/design/visual-design.md#rule-ddr-visual-proofistheaccostedfile)).

```yml accosted
runs:
  - - get_repository_file: { path: pwsh/Base.QualityGates/assets/english.txt.gz }
  - - get_repository_file: { path: pwsh/Base.QualityGates/assets/english.stamp }
  - - test_generated_files: { generator: Build-EnglishDictionary }
```

The same runs in PowerShell, rendered from that file by `Get-AccostedFragment`, never written by hand
([ADR-AUTO-ACCOSTED-ARTICLERENDERING](../../drs/automation/accosted-language.md#rule-adr-auto-accosted-articlerendering)):

```powershell
Get-RepositoryFile -Path 'pwsh/Base.QualityGates/assets/english.txt.gz'

Get-RepositoryFile -Path 'pwsh/Base.QualityGates/assets/english.stamp'

Test-GeneratedFiles -Generator 'Build-EnglishDictionary'
```

## Why it holds

- The English half of the oracle is a committed, version-stamped artifact, built by one command from the pinned cspell, so a spelling
  verdict never depends on what happens to be installed (ADR-AUTO-SPELL).
- An authoring step writes its committed artifact into the source module, never into an installed build (ADR-REPO-OUTDIR-COMPILEDPREBUILD).
- The two files stand in one zone because one run of the command writes both; the gate stands in the next because it is what the files
  cause, not what the command does (DDR-VISUAL-ACTIONISALENS).

The generated-files quality gate proves that the committed files match their inputs today; it does not prove that the word list is complete,
which is the pinned dictionary's promise, not this command's.

## See also

- [Spell out names](../../drs/automation/spell-out-names.md) — the decision this article explains.
- [Visual design](../../drs/design/visual-design.md) — how an action diagram is drawn.
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
