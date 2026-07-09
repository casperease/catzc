# ADR: Customer model (`customer.yml`) — catalogue, two-name binding, and the template switch

Pairs with [`data-model`](azure-data-model.md) (identity + templating) and [`naming-standard`](azure-naming-standard.md); the
enabled-customer set is the `have_customers` repo variant ([repo-variants](../repository/repo-variants.md)).

## Rules: ADR-CUSTOMER

### Rule ADR-CUSTOMER:1

Customer **definitions** live only in `automation/Catzc.Azure/configs/customer.yml` — the catalogue of who the repo's customers are, each a
readable `key` plus a 2-char `shortcode` (and optional `details`). It is split out of `azure.yml` (as `network.yml` split out the IP plan),
loaded by `Get-Config -Config customer` and validated by `Assert-CustomerConfig`.

- [The catalogue](#the-catalogue)

### Rule ADR-CUSTOMER:2

A subscription binds a customer **two ways**: its `customer` field in `azure.yml` may name the customer by **either** its key (`apex`)
**or** its 2-char shortcode (`ap`). Both resolve to the same customer; `Get-AzureCustomer` is the single resolver (keys first, then
shortcodes) and `Get-AzureSubscription` normalizes the token to the canonical key. To keep the binding unambiguous, `Assert-CustomerConfig`
forbids any key from equalling any shortcode.

- [Two names, one binding](#two-names-one-binding)

### Rule ADR-CUSTOMER:3

The subscription→customer reference is **not** validated when `azure.yml` loads. Cross-checking it there would make every `azure.yml` read
also read `customer.yml`, coupling nearly every Azure test to the catalogue. Instead the reference is enforced two other ways: a
shipped-asset **integrity test** (every shipped subscription's customer resolves in `customer.yml`) and **at runtime** (`Get-AzureCustomer`
throws on an unknown token). So `Assert-AzureConfig` validates only azure's own shape, and the cross-asset read is one-directional — the
Azure layer reads the customer catalogue, never the reverse.

- [The reference is checked by integrity and at runtime, not at load](#the-reference-is-checked-by-integrity-and-at-runtime-not-at-load)

### Rule ADR-CUSTOMER:4

Whether the repo does customer deployments — and for which customers — is the `have_customers` **variant** (`false` | `all` | `[names]`),
not `customer.yml`. `customer.yml` is the catalogue of who exists; the variant is which of them this repo actually deploys for. The variant
holds the enabled set so its `Test-`/`Assert-HaveCustomer(s)` primitives can live in `Base` (see
[repo-variants](../repository/repo-variants.md)); an integrity test confirms every name in a `have_customers` list is defined in
`customer.yml`.

- [Catalogue vs enabled set](#catalogue-vs-enabled-set)

### Rule ADR-CUSTOMER:5

A template declares whether it is a customer template with an `options.yml` `customer_deployment` bit (bool), which **defaults to the
`have_customers` variant** (`Test-HaveCustomers`). An explicit `customer_deployment: true` is only permitted when customers are enabled (the
repo gate). The class rule per config is asymmetric: `false` ⇒ the config must **not** live under a customer subfolder (root configs only);
`true` ⇒ a customer subfolder is allowed but its customer must be **enabled** by the variant. `Get-BicepCustomerClassViolations` is the
shared rule used by `Get-BicepTemplates` (fail-fast) and `Assert-BicepTemplate` (collect-all), so the two never drift.

- [The per-template switch and its gate](#the-per-template-switch-and-its-gate)

### Rule ADR-CUSTOMER:6

The customer **key is the configuration subfolder name**: a template's customer configs live at `configuration/<key>/<env>[-<slot>].yml`,
and a subfolder that is not a defined key is a discovery error ([data-model](azure-data-model.md#rule-adr-datamod3)). The shortcode never
names a folder — one spelling on disk, the canonical key.

- [The catalogue](#the-catalogue)

## Context

A customer is a sub-tenant a deployment is made for: its name renders into resource names (the readable key in generous patterns, the 2-char
shortcode in the tight `kv`/`storage`/`vm` patterns — see [naming-standard](azure-naming-standard.md)). Customers began as a `customers` map
inside `azure.yml`, referenced by a subscription's `customer` field. Two pressures pull them into their own asset. First, they are a
distinct concern from identity/topology — the same split [`network-model`](azure-network-model.md) makes for the IP plan. Second, "which
customers this repo deploys for" is a repo-wide policy switch, not a per-subscription fact, and belongs with the other repo variants, kept
separate from the catalogue of who the customers are.

### The catalogue

`customer.yml` declares one entity — a customer — keyed by a readable **`key`** (the customer-segment of relaxed resource names, the value a
subscription may reference, and the name of the customer's `configuration/<key>/` subfolder in every template), with a 2-char
**`shortcode`** (unique; the customer-segment of the restricted patterns) and optional `details`. This mirrors the name/shortcode split
environments already carry. `Assert-CustomerConfig` validates it: key format (`^[a-z][a-z0-9]+$`), shortcode format (`^[a-z]{2}$`),
shortcode uniqueness, and the no-key-equals-a-shortcode rule (ADR-CUSTOMER:2). It is self-contained — it does not read `azure.yml`, so the
customer catalogue sits below the subscriptions that reference it and validation stays one-directional.

### Two names, one binding

A customer has a pair of names — the readable key and the terse shortcode — and a subscription may bind it by either. `Get-AzureCustomer`
resolves a token to the canonical record by trying keys first, then shortcodes; `Get-AzureSubscription` runs the raw `customer` token
through it so the resolved subscription always carries the canonical **key**, whichever form the config used. The binding is unambiguous
only because keys and shortcodes are disjoint name-spaces (a key that equalled a shortcode would match two customers), which
`Assert-CustomerConfig` enforces. This is the [poka-yoke](../principles/poka-yoke.md) form of "accept either spelling, store one".

### The reference is checked by integrity and at runtime, not at load

`network.yml` cross-checks `azure.yml` during its own validation because few tests load `network.yml`. `azure.yml` is different: it is
loaded by almost every Azure test, so making `Assert-AzureConfig` read `customer.yml` to validate the `customer` FK would couple all of them
to the catalogue (and its fixture). The reference is therefore enforced where it costs nothing hermetic:

- a **shipped-asset integrity test** — every shipped subscription's `customer` token resolves via `Get-AzureCustomer`;
- **at runtime** — `Get-AzureSubscription`/`Get-AzureCustomer` throw on an unknown token the moment the subscription is resolved.

So `Assert-AzureConfig` validates only azure's own shape, azure-loading stays hermetic, and the cross-asset dependency runs one way: the
Azure layer reads the customer catalogue, the catalogue reads nothing back.

### Catalogue vs enabled set

Two different questions, two homes. **Who are the customers** is `customer.yml` (the catalogue, an Azure-layer asset). **Which of them does
this repo deploy for** is the `have_customers` variant (`false`/`all`/`[names]`, a Base-layer switch — see
[repo-variants](../repository/repo-variants.md)). Splitting them is deliberate: the enabled set lives in the variant so the
`Test-`/`Assert-HaveCustomer(s)` guards can be answered from `Base` without reading up into the Azure catalogue, and the catalogue stays a
pure list of identities with no policy baked in. The join between them is one integrity test: every name a `have_customers` list enables
must be a defined customer.

### The per-template switch and its gate

A template says whether it is a customer template with `options.yml` `customer_deployment` (bool). Its effective value defaults to the
`have_customers` variant (`Test-HaveCustomers`) unless the template sets it, so a repo with customers disabled (`false`) has only
non-customer templates by default, and an explicit `customer_deployment: true` there is a fail-fast error (the repo gate). The per-config
rule is asymmetric and lives in `Get-BicepCustomerClassViolations`:

- `customer_deployment: false` ⇒ the config must not live under a customer subfolder — a non-customer template ships configuration-root
  configs only;
- `customer_deployment: true` ⇒ a customer subfolder is allowed, but the customer it deploys for must be **enabled** by `have_customers` (so
  `have_customers: [acme]` rejects a `configuration/globex/` config even with the switch on); root configs are still fine.

The rule is shared by discovery (`Get-BicepTemplates`, fail-fast) and the collect-all validator (`Assert-BicepTemplate`), the same
two-caller / one-rule shape as the env-class and subscription-folder checks (see [data-model](azure-data-model.md)).

## Decision

Customer definitions live in `customer.yml` (a self-contained catalogue), referenced by a subscription's `customer` field by key or
shortcode and resolved through `Get-AzureCustomer`; the FK is enforced by integrity + runtime, not at azure load. Which customers are
enabled is the `have_customers` variant, and a template's `customer_deployment` bit (defaulting to that variant, gated by it) decides
whether it may deploy into customer subscriptions.

### How this is enforced

- **`Assert-CustomerConfig`** (private, convention-dispatched) validates `customer.yml` shape, shortcode uniqueness, and the key≠shortcode
  rule.
- **`Get-AzureCustomer`** resolves a key-or-shortcode token to the canonical record and throws on an unknown token;
  **`Get-AzureSubscription`** normalizes a subscription's `customer` to the canonical key.
- **Integrity tests** — every shipped subscription's customer resolves in `customer.yml`; every name in a `have_customers` list is a defined
  customer.
- **`Get-BicepCustomerClassViolations`** — the shared per-config class rule, run by `Get-BicepTemplates` and `Assert-BicepTemplate`;
  `Read-BicepTemplateOptions` validates the `customer_deployment` bool.

## Consequences

- Customers are a first-class asset with a clear boundary: `customer.yml` is who they are, `have_customers` is which the repo deploys for,
  and neither leaks into the other.
- A subscription may reference a customer by the readable key or the terse shortcode, and everything downstream sees the canonical key.
- Azure-config loading stays hermetic — the customer FK is guarded by integrity and runtime, not by coupling every azure read to the
  catalogue.
- The per-template `customer_deployment` bit makes customer-ness an explicit, gated property: disabled repos are non-customer-only by
  default, and a template can only deploy for a customer the repo has enabled.
- The cost is one more asset and one more variant to keep in step — reconciled by the two integrity tests, which are the only place the
  catalogue, the enabled set, and the subscriptions are checked against one another.

## Dora explains

DORA's research links single-source-of-truth configuration and one-living-version practices to faster, more reliable delivery. This ADR
encodes the customer catalogue as the authoritative source, enabling predictable customer-scoped deployments without policy coupling.

- [Version control](https://dora.dev/capabilities/version-control/) — customer catalogue as a versioned, authoritative asset.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — one-living-version principle (no legacy customer
  definitions).
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — customer model drives repeatable deployment patterns.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
