# Flow: The manual queues of the promotion ladder — authoring, two signatures, and an automated blue-green switch

A promoted commit climbs the ladder of [commit-lifecycle](commit-lifecycle.md) (`FDR-CD-LIFE`) through gates. Most of them are code: BVT
rejects a failing commit on its own, CD rolls an artifact onto the next rung on its own. A few are people, and every place a person stands
between two rungs is a queue: work waits there until a human acts, and the wait is the flow's own source of delay
([FDR-CD](cd-discipline-and-promotion-flow.md)). This FDR names every such queue, says who serves it, what store records that it was served,
and which step is never allowed to become one. The pull request as the one door into main belongs to
[server-remote-integration](../design/server-remote-integration.md) (`DDR-REMOTE`); the git mechanics of a topic belong to
[git-topic-flow](git-topic-flow.md) (`FDR-GIT`). This FDR owns the queues.

## Rules: FDR-CD-QUEUE

### Rule FDR-CD-QUEUE-THREEQUEUES

**The promotion ladder has exactly three manual queues, each named, each with a named server, a named store and a measured wait.** A
**manual queue** is a point on the ladder where a commit waits for a person's act before it climbs: the authoring queue before the server's
main, the main-UAT signature before release-uat, and the release-uat signature before pre-prod. Every other climb is automated. A queue is
managed, never merely endured: the rule that owns it says which role serves it, which store records the act, and the wait is measured from
the moment the commit arrives at the queue to the moment the act is recorded. A manual step that no rule here names is a defect of the flow,
not a fourth queue.

- [Three queues, no more](#three-queues-no-more)

### Rule FDR-CD-QUEUE-AUTHORINGISTHEFIRST

**Authoring is the first manual queue: a person edits one catalogue item, pushes it as the authenticated author to the server's topic HEAD,
and from there the change enters main by exactly one of two doors.** The edit is of a code or config item of the catalogue, delivered
downstream, which on the ladder is up: the authoritative push is the authenticated user's own act against the server's topic HEAD, the only
remote ref the clone writes ([FDR-GIT-USERRUNSGIT](git-topic-flow.md#rule-fdr-git-userrunsgit)). From the server's topic HEAD the change
reaches the server's main HEAD either by the platform's atomic pull-request merge, the ingress of
[DDR-REMOTE-PULLREQUESTISINGRESS](../design/server-remote-integration.md#rule-ddr-remote-pullrequestisingress) (an Azure DevOps pull
request, or the equivalent of another host), or by a direct merge from topic HEAD to main HEAD performed by a user whom the server's policy
authorizes to bypass the pull request, in a secure and recorded manner. Both doors merge the server's own verified topic HEAD, never the
clone. The queue's server is the author; its store is the server's history of the topic HEAD and the merge.

- [The authoring queue](#the-authoring-queue)

### Rule FDR-CD-QUEUE-SIGNATUREISTHEGATE

**The RC and RBC gates are each served by one release signature from a user with access, entered in the appointed security registry after
the rung's post-deployment test proved the service loads.** A **release signature** is one recorded act that says "this rung passed its
check" for one named commit: for RC, that main-UAT passed; for RBC, that release-uat passed. The post-deployment test that always proves the
service loads in the rung runs on its own and is the evidence; the signature is the human's authentication of that evidence, not a second
test. The signer is a user the appointed security registry grants access for that rung, and the registry is the one store of the signature:
a signature anywhere else, in a chat, a ticket or a pipeline log, serves no gate. The queue's wait is the time from the rung's test passing
to the signature being recorded.

- [The two signatures](#the-two-signatures)

### Rule FDR-CD-QUEUE-SLOTSWITCHISAUTOMATED

**Pre-prod is hot-swappable with production, blue-green wherever possible, and the switch between them is a monitored, fully automated
procedure with no manual engagement or check.** The **slot switch** is the act that makes the pre-prod occupant the live production occupant
and moves the former production occupant into the staging slot. It is never a queue: no person approves it, triggers it by hand or checks it
on the way; it is observable while it runs and afterwards, and it reverses by the same automated path. Where blue-green is not possible for
a deployable unit, the switch becomes a manual step, and then it is mapped like the three queues above, with its server, its store and its
measured wait named by a rule, never left as an unnamed fourth manual gate.

- [The slot switch](#the-slot-switch)

## Three queues, no more

The ladder's delay has two sources: automated work that takes time, and people who are not there yet. The first is measured by the
pipelines. The second is invisible until each place a person stands is named, so the flow names them, and names exactly three. A commit
waits for its author to push and merge it, waits for a signer to say main-UAT passed, and waits for a signer to say release-uat passed.
Everything else on the ladder runs on its own: BVT, CD onto the on-demand environment, the roll onto each rung, the post-deployment tests,
the slot switch. Each queue has a server, the role that acts, and a store, the place the act is recorded, so the wait can be read from the
store afterwards. A step where a person turns out to be needed and no rule names it is a gap this FDR closes by a rule, not by a habit.

## The authoring queue

A change begins with one person editing one item of the catalogue, a piece of code or config, on a local clone that has no authority
([DDR-REMOTE-SERVERREMOTEISTRUTH](../design/server-remote-integration.md#rule-ddr-remote-serverremoteistruth)). Delivering it downstream
means pushing it upward: the push is the author's own, under the author's own credentials, and its only target is the author's topic branch
on the server. From the server's topic HEAD two doors lead into main. The platform's pull request authenticates the author, runs the merge
gates against the topic HEAD it holds, and performs one atomic merge. A user whom the server's policy authorizes to bypass the pull request
merges the same server-held topic HEAD into main directly, with the bypass itself recorded by the server. Neither door takes anything from
the clone; both take the topic HEAD the server already holds. The queue ends when the merge is in the server's history.

## The two signatures

RC stands after main-UAT and RBC after release-uat ([FDR-CD-TWORELEASEGATES](cd-discipline-and-promotion-flow.md)). Neither is a test: the
rung's post-deployment test runs on its own after the deploy and always proves that the service loads there. What the gate waits for is a
person with access entering one signature in the appointed security registry: "main-UAT passed its check" for commit N, or "release-uat
passed its check" for commit N. The registry is appointed per rung and grants the signers; it is the store the gate reads and the only place
a signature counts. The same person may sign both rungs when the registry grants both, and a team that runs without RBC has only the RC
signature and the queue it serves. The wait of each queue is the time between the test passing and the signature landing, read from the
registry.

## The slot switch

The last climb, from pre-prod to production, is the one step the flow keeps out of human hands. Pre-prod is the staging slot of the
production subscription ([FDR-CD-LIFE-ONECOMMITPERENVIRONMENT](commit-lifecycle.md#rule-fdr-cd-life-onecommitperenvironment)), built so that
it and production can trade places: blue-green, with the switch a procedure a pipeline runs and a person watches. A manual check here would
be a fourth queue at the most expensive point of the ladder, and it would hide behind the signature just given at RBC. So the switch is
automated, monitored while it runs, and reversed by the same path when the monitors say so. A deployable unit that cannot be switched
blue-green does not get an unnamed manual gate: its switch is declared a manual step by a rule of this FDR, with its server, its store and
its measured wait, and the unit's plan says how it becomes automated.
