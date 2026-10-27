# pwsh/Azure.DevOps.BuildValidation/configs/build-validation.yml

The build-validation branch policies tied to globsets: the server-side pre-commit half of a unit's CI binding
([FDR-TYPE-PRECOMMITBUDGET](../../../../drs/flow/pipeline-types.md#rule-fdr-type-precommitbudget)). Each entry binds one declared globset's
native path projection ([FDR-GLOBS](../../../../drs/flow/durable-sha-globs.md)) as the policy's path filter and runs the entry's pipeline as
an Azure DevOps build validation on `branch`.

## Keys

- **`branch`** — the branch the policies guard.
- **`validations`** — a list of entries. A list, because globset names are kebab-case and snake_case key validation forbids hyphenated map
  keys. Each entry holds:
  - `globset` — required, a declared globset name;
  - `pipeline` — defaults to the globset's own `pipeline:` annotation in `globs.yml`;
  - `blocking` — defaults to true;
  - `display_name` — defaults to `Build validation - <globset>`.
- **`policies`** — the pull-request policies of `branch`, applied only when the `git_workspace` variant is `main-via-pr`, since a
  `main-direct` repository has no pull request to guard. Every key is optional and takes the default declared once on the `BranchPolicies`
  type, so a team raises the floor in its own config
  ([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)):
  - `minimum_reviewers` — the fewest approvals, default 1;
  - `creator_vote_counts` — whether the author's own approval counts, default false;
  - `reset_on_push` — whether a new push resets the approvals, default true;
  - `require_comment_resolution` — whether every comment must be resolved, default true;
  - `automatic_reviewer_ids` — ADO identity ids (GUIDs) added to every pull request, default none, since the required-reviewer policy takes
    ids, not names;
  - `merge_types` — the allowed merge types out of `squash`, `no_fast_forward`, `rebase` and `rebase_merge`, default `squash` alone, so a
    pull request lands on main as one commit
    ([FDR-GIT-ONESQUASHEDCOMMIT](../../../../drs/flow/git-topic-flow.md#rule-fdr-git-onesquashedcommit)).

  They answer the CAF branch-policy recommendations
  ([EDR-AZ-CAF-DEVOPS-R25](../../../../drs/external/azure/caf/platform-automation-and-devops.md#rule-edr-az-caf-devops-r25),
  [EDR-AZ-CAF-DEVOPS-R26](../../../../drs/external/azure/caf/platform-automation-and-devops.md#rule-edr-az-caf-devops-r26)).

## Loading and applying

`Get-Config -Config build-validation` loads the file and the `BuildValidationConfig` type validates its shape. `Sync-AdoBuildValidations`
and `Register-AdoBuildValidation` apply the validations to the server, and `Register-AdoBranchPolicies` the policies. A globset's existence
is checked at run time, where `Get-GlobSet` throws on an unknown name, and by an integrity test, never at load, so reading this config stays
hermetic ([ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated)).
