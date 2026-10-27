# Make an emergency change

An emergency change is a change to a production environment that cannot wait for the normal climb from CI through CD to the gated deploy,
because production is down or exposed. It still goes through the repository and a pipeline: the only thing it shortens is the wait, never
the record. The model allows it as an out-of-band topic deploy: the commit reaches an environment without being integrated, and it earns no
mainline promotion state until it lands normally ([commit-lifecycle](../../drs/flow/commit-lifecycle.md#out-of-band-topic-deploys)).

## Make the change

1. Open an incident first (see [respond to an incident](respond-to-an-incident.md)), so the change has an owner and a reason on record.
2. Make the smallest change that ends the emergency on a topic branch, in the template's configuration or the shared module it uses. Change
   one thing, and leave any clean-up for the normal flow.
3. Preview it against the production environment:

   ```powershell
   Deploy-Bicep <environment> <template> -DryRun
   ```

   The what-if lists every resource the change creates, modifies or deletes. Stop when it shows anything beyond the change you meant.

4. Have a second person read the diff and the what-if. An emergency removes the wait, not the second pair of eyes.
5. Run the unit's DEPLOY pipeline for the topic commit. The production environment's Approval check still applies, and the approver group
   approves it at once ([apply the prod-tier approvals](../automation/apply-environment-approvals.md)).
6. Watch the deploy and the alerts until the service is back.

## Close it

1. Open a pull request for the topic commit at once, so it lands on main through CI and CD like any change. Until it lands, the commit is
   deployed but not integrated, and the next normal deploy of that unit would take the change out again.
2. Record in the incident what changed, who approved it, and the commit id.
3. Make the clean-up the emergency skipped as normal changes.
