/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-flow/types/TruthStoresConfig.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Flow;

// Every store the repository touches is declared here, so a new place truth lives cannot appear without a reviewed entry.
public sealed class TruthStoresConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string KindRepository = "version-controlled-repository";
    public const string KindFactSource = "fact-source";
    public const string KindStateMachine = "state-machine";

    // The three kinds of truth store; an adjacent store is not a kind but a projection its repository lists.
    public static readonly IReadOnlyList<string> Kinds = Array.AsReadOnly(new[] { KindRepository, KindFactSource, KindStateMachine });

    // Azure DevOps is two stores: its configuration the repository's projection, its runtime state a fact source the platform owns.
    public static readonly IReadOnlyList<TruthStore> DefaultStores = Array.AsReadOnly(new[]
    {
        new TruthStore("repository", KindRepository, null, null, new[] { "azure-devops-configuration" }),
        new TruthStore("azure-devops", KindStateMachine, null, null),
        new TruthStore("azure-devops-runtime", KindFactSource, null, "azure-devops"),
    });

    private static readonly string[] AllowedKeys = { "stores" };
    private static readonly string[] AllowedStoreKeys = { "kind", "url", "owner", "projections" };
    private static readonly Regex KebabCase = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    // The stores, in declared order.
    public IReadOnlyList<TruthStore> stores { get; }

    public TruthStoresConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        IReadOnlyList<TruthStore> value = DefaultStores;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }
            if (raw.Contains("stores") && raw["stores"] != null)
            {
                value = ReadStores(raw["stores"], errors);
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("truth-stores configuration validation failed:\n" + string.Join("\n", errors));
        }
        stores = value;
    }

    private static IReadOnlyList<TruthStore> ReadStores(object value, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null || map.Count == 0)
        {
            errors.Add("stores must be a non-empty map of <store>: { kind, url, owner, projections }");
            return Array.Empty<TruthStore>();
        }

        List<TruthStore> found = new List<TruthStore>();
        foreach (DictionaryEntry entry in map)
        {
            string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            if (!KebabCase.IsMatch(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}' is not kebab-case", name));
            }
            IDictionary fields = entry.Value as IDictionary;
            if (fields == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}' must be a map of kind, url, owner and projections", name));
                continue;
            }
            foreach (object key in fields.Keys)
            {
                string field = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedStoreKeys, field) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}': unknown key '{1}' (allowed: {2})", name, field, string.Join(", ", AllowedStoreKeys)));
                }
            }
            string kind = fields["kind"] as string;
            if (kind == null || !Contains(Kinds, kind))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}': kind '{1}' is not one of: {2}", name, kind, string.Join(", ", Kinds)));
            }
            string url = fields["url"] as string;
            if (url != null && !(Uri.TryCreate(url, UriKind.Absolute, out Uri parsed) && (parsed.Scheme == Uri.UriSchemeHttps || parsed.Scheme == Uri.UriSchemeHttp)))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}': url '{1}' is not an absolute http or https URL", name, url));
            }
            string owner = fields["owner"] as string;
            List<string> projections = new List<string>();
            if (fields.Contains("projections") && fields["projections"] != null)
            {
                IList listed = fields["projections"] as IList;
                if (listed == null)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}': projections must be a list of adjacent store names", name));
                }
                else if (kind != KindRepository)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}': only a version-controlled repository lists projections, since an adjacent store is driven from one", name));
                }
                else
                {
                    foreach (object item in listed)
                    {
                        string projection = Convert.ToString(item, CultureInfo.InvariantCulture);
                        if (projection == null || !KebabCase.IsMatch(projection))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}': projection '{1}' is not kebab-case", name, projection));
                            continue;
                        }
                        projections.Add(projection);
                    }
                }
            }
            found.Add(new TruthStore(name, kind, url, owner, projections.ToArray()));
        }

        // An owner names a state machine of the same map; a fact source always names one.
        foreach (TruthStore store in found)
        {
            if (store.owner == null)
            {
                if (store.kind == KindFactSource)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}': a fact source names the state machine that owns it in 'owner'", store.name));
                }
                continue;
            }
            TruthStore owner = found.Find(candidate => string.Equals(candidate.name, store.owner, StringComparison.Ordinal));
            if (owner == null || owner.kind != KindStateMachine)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "store '{0}': owner '{1}' is not a state machine of this config", store.name, store.owner));
            }
        }
        return found.AsReadOnly();
    }

    private static bool Contains(IReadOnlyList<string> items, string item)
    {
        foreach (string candidate in items)
        {
            if (string.Equals(candidate, item, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }
}
