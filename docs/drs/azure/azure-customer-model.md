# Azure: Customer model (customer.yml) — catalogue, two-name binding, and the template switch

Pairs with [`data-model`](azure-data-model.md) (identity + templating) and [`naming-standard`](azure-naming-standard.md); the
enabled-customer set is the `have_customers` repo variant.

## Rules: ADR-AZ-CUSTOMER

### Rule ADR-AZ-CUSTOMER-ONECATALOGUE

Customer **definitions** live only in `pwsh/Azure/configs/customer.yml` — the catalogue of who the repo's customers are, each a readable
`key` plus a 2-char `shortcode` (and optional `details`). It is separate from `azure.yml` (as `network.yml` holds the IP plan), loaded by
`Get-Config -Config customer` and validated by its config type, `CustomerConfig`.

- [The catalogue](#the-catalogue)

### Rule ADR-AZ-CUSTOMER-TWOBINDINGS

A subscription binds a customer **two ways**: its `customer` field in `azure.yml` may name the customer by **either** its key (`apex`)
**or** its 2-char shortcode (`ap`). Both resolve to the same customer; `Get-AzureCustomer` is the single resolver (keys first, then
shortcodes) and `Get-AzureSubscription` normalizes the token to the canonical key. To keep the binding unambiguous, `CustomerConfig` forbids
any key from equalling any shortcode.

- [Two names, one binding](#two-names-one-binding)

### Rule ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED

The subscription→customer reference is **not** validated when `azure.yml` loads. Cross-checking it there would make every `azure.yml` read
also read `customer.yml`, coupling nearly every Azure test to the catalogue. Instead the reference is enforced two other ways: a
shipped-asset **integrity test** (every shipped subscription's customer resolves in `customer.yml`) and **at runtime** (`Get-AzureCustomer`
throws on an unknown token). So `AzureConfig` validates only azure's own shape, and the cross-asset read is one-directional — the Azure
layer reads the customer catalogue, never the reverse.

- [Checking the reference](#checking-the-reference)

### Rule ADR-AZ-CUSTOMER-HAVECUSTOMERSVARIANT

Whether the repo does customer deployments — and for which customers — is the `have_customers` **variant** (`false` | `all` | `[names]`),
not `customer.yml`. `customer.yml` is the catalogue of who exists; the variant is which of them this repo actually deploys for. The variant
holds the enabled set so its `Test-`/`Assert-HaveCustomer(s)` primitives can live in `Base`; an integrity test confirms every name in a
`have_customers` list is defined in `customer.yml`.

- [Catalogue vs enabled set](#catalogue-vs-enabled-set)

### Rule ADR-AZ-CUSTOMER-TEMPLATEFROMFOLDER

Whether a template is a customer template is **inferred from its folders**: it is one exactly when it has a customer subfolder under
`configuration/` (ADR-AZ-CUSTOMER-KEYISSUBFOLDER), and nothing in `options.yml` says so. A customer subfolder is only permitted when
customers are enabled by the `have_customers` variant (the repo-level guard), and its customer must be **enabled** by the variant; a
template with root configs only is a non-customer template. `Get-BicepCustomerClassViolations` is the shared rule used by
`Get-BicepTemplates` (fail-fast) and `Assert-BicepTemplate` (collect-all), so the two never drift.

- [The per-template switch](#the-per-template-switch)

### Rule ADR-AZ-CUSTOMER-KEYISSUBFOLDER

The customer **key is the configuration subfolder name**: a template's customer configs live at `configuration/<key>/<env>[-<slot>].yml`,
and a subfolder that is not a defined key is a discovery error
([ADR-AZ-DATAMOD-NAMEKEYEDMAPS](azure-data-model.md#rule-adr-az-datamod-namekeyedmaps)). The shortcode never names a folder — one spelling
on disk, the canonical key.

- [The catalogue](#the-catalogue)

## Context

A customer is a sub-tenant a deployment is made for: its name renders into resource names (the readable key in generous patterns, the 2-char
shortcode in the tight `kv`/`storage`/`vm` patterns — see [naming-standard](azure-naming-standard.md)). A subscription references one
through its `customer` field. Two pressures give customers their own asset, separate from `azure.yml`. First, they are a distinct concern
from identity/topology — the same split [`network-model`](azure-network-model.md) makes for the IP plan. Second, "which customers this repo
deploys for" is a repo-wide policy switch, not a per-subscription fact, and belongs with the other repo variants, kept separate from the
catalogue of who the customers are.

### The catalogue

`customer.yml` declares one entity — a customer — keyed by a readable **`key`** (the customer-segment of relaxed resource names, the value a
subscription may reference, and the name of the customer's `configuration/<key>/` subfolder in every template), with a 2-char
**`shortcode`** (unique; the customer-segment of the restricted patterns) and optional `details`. This mirrors the name/shortcode split
environments carry. Its config type, `CustomerConfig`, validates it at load: key format (`^[a-z][a-z0-9]+$`), shortcode format
(`^[a-z]{2}$`), shortcode uniqueness, and the no-key-equals-a-shortcode rule (ADR-AZ-CUSTOMER-TWOBINDINGS). It is self-contained — it does
not read `azure.yml`, so the customer catalogue sits below the subscriptions that reference it and validation stays one-directional.

### Two names, one binding

A customer has a pair of names — the readable key and the terse shortcode — and a subscription may bind it by either. `Get-AzureCustomer`
resolves a token to the canonical record by trying keys first, then shortcodes; `Get-AzureSubscription` runs the raw `customer` token
through it so the resolved subscription always carries the canonical **key**, whichever form the config used. The binding is unambiguous
only because keys and shortcodes are disjoint name-spaces (a key that equalled a shortcode would match two customers), which
`CustomerConfig` enforces. This is the [poka-yoke](../principles/poka-yoke.md) form of "accept either spelling, store one".

### Checking the reference

`The reference is checked by integrity and at runtime, not at load`

A config type validates its own file and never reads another config: a cross-asset join is checked outside the load (the
`network.yml`↔`azure.yml` join is the `Test-AzureNetworkPlan` quality gate). The customer reference matters most because `azure.yml` is
loaded by almost every Azure test, so making `AzureConfig` read `customer.yml` to validate the `customer` FK would couple all of them to the
catalogue (and its fixture). The reference is therefore enforced where it costs nothing hermetic, by an integrity test and at runtime
(ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED), and the dependency runs one way: the Azure layer reads the catalogue, never the reverse.

### Catalogue vs enabled set

Two different questions, two homes. **Who are the customers** is `customer.yml` (the catalogue, an Azure-layer asset). **Which of them does
this repo deploy for** is the `have_customers` variant (`false`/`all`/`[names]`, a Base-layer switch). Splitting them is deliberate: the
enabled set lives in the variant so the `Test-`/`Assert-HaveCustomer(s)` guards can be answered from `Base` without reading up into the
Azure catalogue, and the catalogue stays a pure list of identities with no policy baked in. The join between them is one integrity test:
every name a `have_customers` list enables must be a defined customer.

### The per-template switch

`The per-template switch and its gate`

A template's folders say whether it is a customer template: its `customer_deployment` is true exactly when a customer subfolder sits under
its `configuration/`. A second declaration in `options.yml` could only agree with the folders or contradict them, so the folder is the one
source. The per-config rule lives in `Get-BicepCustomerClassViolations`:

- a configuration-root config is always fine — a template with root configs only is a non-customer template;
- a customer subfolder needs customers enabled (`Test-HaveCustomers`; a repo with `have_customers: false` rejects any customer subfolder,
  the repo-level guard), and the customer it deploys for must be **enabled** by `have_customers` (so `have_customers: [acme]` rejects a
  `configuration/globex/` config).

The rule is shared by discovery (`Get-BicepTemplates`, fail-fast) and the collect-all validator (`Assert-BicepTemplate`), the same
two-caller / one-rule shape as the env-class and subscription-folder checks (see [data-model](azure-data-model.md)).

## Decision

Customer definitions live in `customer.yml` (a self-contained catalogue), referenced by a subscription's `customer` field by key or
shortcode and resolved through `Get-AzureCustomer`; the FK is enforced by integrity + runtime, not at azure load. Which customers are
enabled is the `have_customers` variant, and a template is a customer template when it has a customer subfolder, each guarded by that
variant.

### A customer in the one tenant

Every customer is a subscription pair in the one tenant ([ADR-AZ-CUSTOMER-TWOBINDINGS](#rule-adr-az-customer-twobindings)), and its
isolation comes from the subscription: its own landing zone, network, budget, workspace, vault, CD pipeline, and service connections. The
landing zone depends on it: a spoke peers to the hub in a shared subscription, the hub's private DNS zones link to every spoke, and a
workload registers its private endpoints in the hub's zones ([ADR-AZ-LZ-HUBANDSPOKE](landing-zones.md#rule-adr-az-lz-hubandspoke)). Within
one tenant each join needs only a role on the other side, and the one SQL administrator group administers every customer's server. A
customer whose contract or regulation demands its own directory would be a second `tenants` entry and a design change, needing a hub of its
own. Experiments run as an ephemeral slot of a non-production subscription (`dev-blu` on `apex/dev.yml`,
[ADR-AZ-DATAMOD-EPHEMERALSLOT](azure-data-model.md#rule-adr-az-datamod-ephemeralslot)), inside the same tenant and behind the same
guardrails; an experiment needing what the landing zone denies would be the trigger for a sandbox subscription declared in the same tenant.

### How this is enforced

- **`CustomerConfig`** (the C# config type registered for `customer` in `configs.yml`) validates `customer.yml` at load: its shape, key and
  shortcode formats, shortcode uniqueness, and the key≠shortcode rule, reporting every violation in one error.
- **`Get-AzureCustomer`** resolves a key-or-shortcode token to the canonical record and throws on an unknown token;
  **`Get-AzureSubscription`** normalizes a subscription's `customer` to the canonical key.
- **Integrity tests** — every shipped subscription's customer resolves in `customer.yml`; every name in a `have_customers` list is a defined
  customer.
- **`Get-BicepCustomerClassViolations`** — the shared per-config class rule, run by `Get-BicepTemplates` and `Assert-BicepTemplate`, over
  the customer subfolders a template has.

## Consequences

- Customers are a first-class asset with a clear boundary: `customer.yml` is who they are, `have_customers` is which the repo deploys for,
  and neither leaks into the other.
- A subscription may reference a customer by the readable key or the terse shortcode, and everything downstream sees the canonical key.
- Azure-config loading stays hermetic — the customer FK is guarded by integrity and runtime, not by coupling every azure read to the
  catalogue.
- A template's customer-ness is visible in its folders and guarded: a repo with customers disabled has non-customer templates only, and a
  template can only deploy for a customer the repo has enabled.
- The cost is one more asset and one more variant to keep in step — reconciled by the two integrity tests, which are the only place the
  catalogue, the enabled set, and the subscriptions are checked against one another.
