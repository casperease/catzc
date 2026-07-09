# ADR: DORA — Well-being

## Rules: ADR-DORAWB

### Rule ADR-DORAWB:1

Well-being is a directly measured outcome — individuals' happiness and job satisfaction — because DORA's research ties it to organizational
performance and job tenure, not a soft afterthought layered onto delivery metrics after the fact.

- [Summary](#summary)

### Rule ADR-DORAWB:2

Reduce deployment pain — the fear and anxiety of pushing code to production — with the same technical practices that drive continuous
delivery; a painful release process is a well-being problem with a delivery-practice fix, not a separate morale program.

- [How to apply](#how-to-apply)

### Rule ADR-DORAWB:3

Track and shrink rework — unplanned, reactive work such as break/fix, emergency patches, and firefighting — because the ratio of new work to
rework is simultaneously a quality signal and a well-being signal: teams that spend more time firefighting report worse outcomes on both.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAWB:4

Treat burnout as a property of the work environment, never a property of the person — address Maslach's six organizational risk factors
(overload, lack of control, insufficient reward, breakdown of community, absence of fairness, value conflict) by changing how work is
organized, not by asking individuals to cope better.

- [Common pitfalls](#common-pitfalls)

## Context

Well-being sits in the DORA Core Model as an outcome, not a technical capability like version control or continuous delivery — it is a
downstream measure of how the rest of the model's practices land on the people doing the work. DORA defines it as "a reflection of
individuals' happiness and job satisfaction" and finds that "increased well-being predicts organizational performance and employees' job
tenure."[^1] DORA studies three specific contributors to well-being: deployment pain, rework, and burnout.

Because well-being is an outcome rather than a lever pulled directly, improving it is indirect: strengthen the technical and process
capabilities that reduce deployment pain and rework, and address the organizational conditions — not the individuals — that produce burnout.

## Summary

The capability is well-being: individuals' happiness and job satisfaction, which DORA treats as an outcome that predicts organizational
performance and job tenure. DORA studies three contributors — deployment pain (the fear and anxiety of pushing code to production), rework
(time spent on unplanned, reactive work instead of new work), and burnout (exhaustion driven by the work environment) — and finds all three
move together with delivery performance: painful deployments, high rework, and burnout risk factors cluster where software delivery and
organizational performance are weakest.

## Why it matters

DORA ties well-being to delivery performance through a shared cause, not a coincidence: the same technical practices that produce fast,
stable delivery also remove the sources of pain. "Teams can reduce deployment pain by implementing the technical practices that drive
continuous delivery," because the practices that improve the ability to deliver software with speed and stability are the same ones that
reduce the stress and anxiety of pushing code into production.

High performers also spend their time differently. DORA's surveys found high performers reporting 49 percent of their time on new work and
21 percent on unplanned work or rework, against 38 percent and 27 percent for low performers — high performers spend 29 percent more time on
new work and 22 percent less time on rework. Continuous delivery predicts lower levels of unplanned work and rework in a statistically
significant way, so implementing its technical practices drives higher quality as well as less firefighting. Burnout follows the same
pattern: it correlates with pathological cultures and wasteful, unproductive work, so fixing delivery practices and culture also treats the
conditions that produce burnout.

## How to apply

This platform reduces the two contributors within engineering's direct control. Deployment pain shrinks through the CI discipline and
promotion flow ([ADR-FLOW](../design/ci-discipline-and-promotion-flow.md)), which keeps releases small, frequent, and mechanically gated
rather than rare and high-stakes. Rework shrinks through fail-fast inline assertions
([ADR-FAILFAST](../automation/fail-fast-with-asserts.md)), which surface a broken assumption at its exact point of failure instead of days
later as an unplanned firefight, and through the zero-ceremony, hard-to-fail design ([ADR-ZERO](../automation/zero-ceremony-poka-yoke.md)),
which prevents whole classes of mistakes structurally so they never become rework at all. None of this reaches the organizational risk
factors behind burnout directly — those are a matter of how the organization manages people, not of platform design — but shrinking
deployment pain and rework removes two of DORA's three named contributors to poor well-being.

## Common pitfalls

- **Treating deployment pain as an attitude problem.** Coaching people to be less anxious about releases instead of making releases smaller,
  more frequent, and less disruptive leaves the actual cause untouched.
- **Not tracking rework.** Without a measure of time spent on unplanned work versus new work, a team can drift toward firefighting for
  months before anyone notices the ratio has flipped.
- **Fixing the person instead of the environment.** Maslach found that "most organizations try to fix the person and ignore the work
  environment, even though data shows that fixing the environment has a higher likelihood of success" — replacing or individually coaching a
  burned-out engineer instead of addressing overload, lack of control, insufficient reward, broken community, unfairness, or value conflict
  in how work is organized.
- **Treating well-being as a soft metric with no lever.** Well-being is downstream of concrete, changeable practices; leaving it as an
  unexamined survey number disconnects it from the deployment-pain and rework work that would actually move it.

## References

[^1]:
    DORA, _Well-being_ capability, <https://dora.dev/capabilities/well-being/>. An outcome measure in the DORA Core Model, reflecting how
    the surrounding technical and organizational capabilities land on the people doing the work.

## Dora explains

Well-being closes the loop between DORA's technical and process capabilities and the people applying them: it is not a lever pulled directly
but the outcome those capabilities are ultimately judged by, alongside organizational performance and job tenure.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the practices that reduce deployment pain are the same ones
  that predict faster, safer releases.
- [Job satisfaction](https://dora.dev/capabilities/job-satisfaction/) — the closely related individual outcome DORA tracks alongside
  well-being.
- [Generative organizational culture](https://dora.dev/capabilities/generative-organizational-culture/) — the culture whose absence
  Maslach's six burnout risk factors describe.
- [Transformational leadership](https://dora.dev/capabilities/transformational-leadership/) — the management responsibility DORA assigns for
  fixing the work environment rather than the individual.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
