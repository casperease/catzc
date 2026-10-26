# EDR: Lean — the Toyota Production System, mapped to software by the Poppendiecks

## Rules: EDR-LEAN

Each rule is one claim of the lean literature: Ohno's Toyota Production System, the Poppendiecks' mapping of it to software, and the two
laws that make flow quantitative. The sentence is the repository's own summary, never a quotation.

### Rule EDR-LEAN-TOYOTAPRODUCTIONSYSTEM

The Toyota Production System rests on two pillars: just-in-time flow (value moves, pulled by downstream demand, without waiting) and jidoka
(build quality in; on a defect the line stops and the defect is fixed at its source). The goal is the fastest sustainable flow from concept
to cash, with quality built in rather than inspected in.

Source: Taiichi Ohno, _Toyota Production System: Beyond Large-Scale Production_ (1988)

Binds to [WDR-PULLWORK-PULLNOTPUSH](../../process/pull-work.md#rule-wdr-pullwork-pullnotpush) and
[WDR-ANDON-FAILINGGATESTOPSLINE](../../process/holding-the-line.md#rule-wdr-andon-failinggatestopsline).

### Rule EDR-LEAN-POPPENDIECKPRINCIPLES

The Poppendiecks map the Toyota Production System to software as seven principles: eliminate waste, build quality in, create knowledge,
defer commitment, deliver fast, respect people, and optimise the whole.

Source: Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003)

Binds to [PDR-NOWASTE-DROPUNNEEDEDSTEPS](../../principles/reduce-waste.md#rule-pdr-nowaste-dropunneededsteps),
[WDR-BUILTIN-QUALITYBUILTIN](../../process/build-quality-in.md#rule-wdr-builtin-qualitybuiltin),
[WDR-KAIZEN-AMPLIFYLEARNING](../../process/inspect-and-adapt.md#rule-wdr-kaizen-amplifylearning),
[WDR-PULLWORK-DEFERCOMMITMENT](../../process/pull-work.md#rule-wdr-pullwork-defercommitment),
[WDR-QUEUECOST-QUEUETIMEDOMINATES](../../process/queues-cost-money.md#rule-wdr-queuecost-queuetimedominates), and
[WDR-LEANTERMS-OPTIMISETHEWHOLE](../../process/process-terms.md#rule-wdr-leanterms-optimisethewhole).

### Rule EDR-LEAN-SEVENWASTES

Lean names seven wastes, work that does not contribute to the outcome; the Poppendiecks adapt them to software as partially done work, extra
features, relearning, handoffs, task switching, delays, and defects.

Source: Mary and Tom Poppendieck, _Implementing Lean Software Development: From Concept to Cash_ (2006)

Binds to [PDR-NOWASTE-SEVENWASTESCITED](../../principles/reduce-waste.md#rule-pdr-nowaste-sevenwastescited).

### Rule EDR-LEAN-ISQUANTITATIVE

Little's Law makes flow quantitative: for a stable system, average flow time equals average work-in-progress divided by average throughput,
whatever the arrival or service distribution. With throughput near-fixed, work-in-progress is the lever on lead time.

Source: John D. C. Little, "A Proof for the Queuing Formula: L = λW", _Operations Research_ 9 (1961)

Binds to [WDR-QUEUECOST-LITTLESLAW](../../process/queues-cost-money.md#rule-wdr-queuecost-littleslaw),
[WDR-QUEUECOST-DELAYHASAPRICE](../../process/queues-cost-money.md#rule-wdr-queuecost-delayhasaprice), and
[WDR-LEANTERMS-FLOWISMEASURED](../../process/process-terms.md#rule-wdr-leanterms-flowismeasured).

### Rule EDR-LEAN-COMPUTEOVERATTENTION

Moore's observation is that compute capacity per unit cost roughly doubles on a regular cadence, so machine time trends towards free while
human attention stays scarce and expensive.

Source: Gordon E. Moore, "Cramming More Components onto Integrated Circuits", _Electronics_ (1965)

Binds to [WDR-QUEUECOST-ATTENTIONISTHECONSTRAINT](../../process/queues-cost-money.md#rule-wdr-queuecost-attentionistheconstraint) and
[WDR-LEANTERMS-AUTOMATEDORMANUAL](../../process/process-terms.md#rule-wdr-leanterms-automatedormanual).

### Rule EDR-LEAN-LEANANDAGILE

The Poppendiecks present lean software development as an agile toolkit: the Toyota Production System's flow discipline supplies the
mechanism by which an agile process keeps the cost of change low.

Source: Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003)

Binds to [WDR-KAIZEN-LEANISPOPPENDIECK](../../process/inspect-and-adapt.md#rule-wdr-kaizen-leanispoppendieck).

## Context

Lean is as overloaded as agile ([EDR-AGILE](../agile/agile.md)): it names Toyota's production system, a startup methodology, a family of
consultancies, and a cost-cutting euphemism. This record fixes the one meaning the repository draws on, Ohno's Toyota Production System as
mapped to software by Mary and Tom Poppendieck. The sources are published books and papers; this record summarises them and quotes none.
