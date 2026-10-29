# Slide style and ideas

What the thirteen proof-of-concept decks taught about slides for people, and the ideas from them worth a real slide. The decks built the
slide machine and are gone; this page keeps what they found. Each idea names its source deck and slide, so `git log` finds the original.

The decks read: product-thesis, truth-travels, gates-and-robots, for-developer, a-day-in-cats, jokes-automation, delivery-ladder,
manual-queues, vendor-for-sre-lead, pairs-of-rules, repository-shape, setting-travels and things-that-are-not. Their diagram renderings were
judged bad and are not a model for anything here.

## Style that worked

- **One claim per slide, the title a full sentence.** "Remove the problem instead of managing it" (product-thesis, decision); "A gate that
  can hang is no gate" (truth-travels, every-wait-bounded). The reader gets the point from the title alone.
- **A short lead that names the cost of the alternative.** "Write-Error leaves the pipeline green" (pairs-of-rules, gate-needs-throw); "a
  batch edit fails silently and costs more to unwind than it saved" (a-day-in-cats, edit-one-file).
- **Two headline forms that carry a rule in a few words.** The negation, "not X" with the one alternative in the lead (things-that-are-not,
  not-a-monolith), and the seam, "X needs Y" (pairs-of-rules, config-needs-order).
- **A story spine.** The strongest decks move: product-thesis goes problem, decision, principles, close; a-day-in-cats follows one working
  day in time order; setting-travels follows one setting from principle into code; truth-travels walks down into code and back up with
  direction words ("down into implementation", "back at the top").
- **Varied patterns that give a deck rhythm.** Part dividers, a pair of cards for a two-sided idea ("Inside the trunk / At the boundary"),
  tiles for a whole set at a glance, a small table that makes an abstract claim concrete (product-thesis, boundary, foundation, service).
- **A progress counter** ("3 / 15") so the audience knows where they are.
- **Verifiability.** A "check it" pointer per claim and a closing "every claim on these slides is checked" slide build trust; so does a
  candid slide on what is not gated yet (truth-travels, only-bvt-in-code; truth-travels, every-claim-checkable).
- **Humour that stays exact.** A joke as the title with the plain rule in the lead works when the joke's consequence is also the correct
  behaviour: "the pipeline turned red, which is the correct behaviour" (jokes-automation, livingston-on-the-keyboard); "Main has two doors
  and no windows" (manual-queues, two-doors). About three funny slides in ten is the right ratio.
- **Concrete numbers and names.** "A robot is a body of at most twenty lines" (gates-and-robots, robot-is-twenty-lines); "a commit waits for
  a person in exactly three places" (manual-queues, three-queues).
- **Speaker notes carry the "so what"** in one or two sentences ("rule five saves meetings", product-thesis, config).

## Style that did not work

- **Record codes on the visible surface.** Codes in the eyebrow, the title or a table's first column are noise for people; they belong in
  the notes.
- **Pictures not chosen for the claim.** A reduced catalogue diagram under an unrelated fact, the same picture under several claims, and
  captions that describe the picture ("From the catalogue, reduced: …") instead of the point. A picture earns its place only by showing the
  claim; otherwise the slide is text.
- **A flat list.** Thirty facts at the same weight, one pattern on every slide, no dividers and no payoff read as an index, not a talk
  (for-developer, vendor-for-sre-lead).
- **A pasted audience prefix.** "For the Developer, who …" or "For the SRE Lead, who …" on every slide repeats the audience instead of
  re-angling each fact for them.
- **Unexplained terms.** Rung, BVT, RC, RBC, UAT, occupant, accosted, drone, burst: explain each once or say it plainly.
- **Repeats across decks.** The three queues, the slot switch, the dirty head and secrets-at-deploy each appeared in three decks; the
  closing "this deck is checked" slide was copied into every deck.
- **Leads of two or three sentences** and internal tooling slides (heads, registers, run locks) shown to an audience that does not run them.
- **Jokes that need the inside story** ("accosted" in jokes-automation, sarah-and-the-accosted) or that name real people.

## Ideas worth a real slide

### The core idea: one source of truth

- Delivery is slow because the truth about a system lives in many stores that drift apart. Every engineer has been bitten by drift.
  (product-thesis, problem)
- Remove the problem instead of managing it: the repository is the one truth, and a commit is both the change and its delivery.
  (product-thesis, decision; for-developer, tdr-onetruth-1)
- Truth lives in three kinds of store: the one the system writes, the ones it reads, the ones it meets. (product-thesis, stores;
  for-developer, tdr-stores-2)
- A fact stated twice drifts, so keep each fact at one source and derive the rest. (for-developer, tdr-normalform-3)
- Approval, change record and audit are not separate systems: they are a step, a commit and the history. (product-thesis, service)
- Code replaces the inventory database, and every query answers as typed data any tool can read. (product-thesis, record)

### One living version

- No back-compat shim, alias or fallback: change the contract and every caller together, and delete the old shape. (things-that-are-not,
  not-back-compat; product-thesis, onelive)
- One source of truth needs one living version, since a second version is a second truth. (pairs-of-rules, truth-needs-one-version)
- A mono repo, not a monolith: each unit versions and releases on its own, with no repo-wide freeze. (things-that-are-not, not-a-monolith;
  for-developer, rdr-dora-looseteams-19)
- A record reads present tense; git holds the path. (things-that-are-not, not-a-changelog)

### Configure, don't program

- Behaviour that varies is a config entry, so a new instance is a config line and no new code. (setting-travels, varying-is-config;
  product-thesis, config)
- A default is declared once; a value is resolved caller first, then config, then default. (setting-travels, default-declared-once,
  one-resolution-order)
- A customer is a slot in the data model: adding one is a config change. (vendor-for-sre-lead, adr-az-customer-16)
- No magic numbers: a size, limit or colour is config with one declared default. (things-that-are-not, not-a-magic-number)
- One way to do each thing; a second way is a defect, one more place for a fault to hide. (setting-travels, one-way-each-thing)

### Fail early, fail loud

- A mistake is caught at the earliest point, and the error says what was given and what is allowed. (truth-travels, earliest-detection)
- Errors are thrown, never written, so a bad run can never go green. (truth-travels, throw-not-write; jokes-automation,
  livingston-on-the-keyboard)
- Every wait is bounded: a gate that can hang is no gate, and a denied call goes to a person, never retried with a bigger number.
  (truth-travels, every-wait-bounded; gates-and-robots, bound-every-wait; jokes-automation, sarah-reads-the-log)
- A name that does not fit fails; it is never silently shortened. (vendor-for-sre-lead, adr-az-naming-nevertruncate-10)
- Prevent mistakes by structure (the folder is the module, nothing to register); detect at once where structure cannot. (product-thesis,
  pokayoke; repository-shape, one-function-one-file)

### Gates are commands

- A quality gate is one command with one verdict, run the same by a person, a robot and a pipeline: no "works on my machine".
  (gates-and-robots, gate-is-a-command)
- A pipeline step only names a command a developer can run locally. (vendor-for-sre-lead, adr-ado-template-3)
- Every test level has a time roof in one config; a run over it is a finding, and a person raises the roof. (gates-and-robots,
  levels-have-roofs; vendor-for-sre-lead, adr-az-waf-pe-30)
- A gate counts as passed only when it ran and its output was read. (a-day-in-cats, run-the-gate)
- Every finding names its file and line, and blames nobody. (for-developer, rdr-dora-observ-16)

### One artifact climbs the ladder

- One artifact is built once and climbs to production unchanged: no "it worked on staging". (truth-travels, one-artifact-climbs;
  for-developer, rdr-dora-deploy-9)
- The automated quality gate rejects a bad commit alone, and the next climb leaves from the last verified commit, never from the tip.
  "Landing is not verifying." (delivery-ladder, bvt-rejects-alone, dirty-head-unsafe; manual-queues, leave-from-verified)
- Each environment holds one occupant, and production remembers the rest, so you can always say what is where. (delivery-ladder,
  one-occupant-per-env)
- Production swaps by an automated, monitored, reversible switch with no approver: reliability is a rung, not a hope. (manual-queues,
  switch-is-automated; vendor-for-sre-lead, adr-az-waf-re-27)
- Config and schema changes ride in the same commit as the code. (for-developer, rdr-dora-dbchange-13)

### People and the manual steps

- A commit waits for a person in exactly three places, and nowhere else. (manual-queues, three-queues)
- Main has two doors and no windows: the pull-request merge and a recorded bypass. (manual-queues, two-doors)
- A signature is one entry in one registry; a thumbs-up in chat opens no gate. (manual-queues, signature-is-the-gate, registry-not-chat)
- The wait is a number read from the store, not a feeling. (manual-queues, wait-is-measured)
- A manual step no rule names is a defect: the ladder keeps no secret stairs. (manual-queues, no-secret-stairs)
- The server is the one authority; a local clone has none, however many tests it ran. (truth-travels, server-is-truth; things-that-are-not,
  not-a-clone-with-authority)

### Robots and people

- The robot reads and advises; the person commits and pushes. (for-developer, rdr-dora-userfocus-30; gates-and-robots, no-mutating-git)
- A robot is small (twenty lines) because a shared contract carries the rest. (gates-and-robots, robot-is-twenty-lines; pairs-of-rules,
  robots-need-contract)
- A delegated robot edits only what its brief owns and asks its coordinator, never the user. (a-day-in-cats, ask-the-coordinator)
- A learning survives only when the tree proves it. (a-day-in-cats, learn-then-hindsight; gates-and-robots, hindsight-is-checked)

### Day to day

- Every change lands as one squashed commit, and a topic syncs by rebase, so history is a list of readable changes. (delivery-ladder,
  one-squashed-commit, topic-syncs-by-rebase)
- Edit one file at a time and verify it before the next. (a-day-in-cats, edit-one-file)
- Read the index first: the rules are bigger than any one reading, so a task reads only what its files cite. (a-day-in-cats,
  read-the-index-first)
- Where a file lives says what it is; imported code lands in an inbox track and leaves by one move. (repository-shape, kinds-are-tracks,
  unordered-is-the-landing)
- Secrets are injected only at deploy; the repository holds a template. (vendor-for-sre-lead, adr-ado-var-4)
- The landing zone and the network are declared in code and compared with what is live, not clicked. (vendor-for-sre-lead, adr-az-lz-12)
- Nothing reaches a package feed outside the tooling: the supply chain is the repository. (things-that-are-not, not-a-package-feed)

## For the next decks

Pick one audience and one arc, open with a problem the audience has felt, and close on the win. Keep one claim per slide with a lead that
names the failure it prevents, vary the patterns, explain each term once, and show a picture only when it shows the claim. Merge the
repeated facts above into one slide each, keep the codes and the "check it" pointers in the notes, and end with one "every claim is checked"
slide per show, not per deck.
