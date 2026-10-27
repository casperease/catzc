using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text;

namespace Catzc.Azure.Templates;

public static class ArmScopeFunction
{
    // The value of name(args) over the deployment facts { location, subscriptionId, resourceGroupName }; null holds none of them.
    public static object Call(string name, List<object> args, IDictionary deployment)
    {
        object unresolved = ArmExpression.Unresolved;
        if (args.Exists(ArmExpression.IsUnresolved)) { return unresolved; }
        string location = Fact(deployment, "location");
        string subscriptionId = Fact(deployment, "subscriptionId");
        string resourceGroupName = Fact(deployment, "resourceGroupName");
        switch (name)
        {
            case "deployment":
                // ARM's deployment() also holds its name and properties; the location is the one member the caller passes.
                if (args.Count != 0 || location == null) { return unresolved; }
                return Facts("location", location);
            case "subscription":
                if (args.Count != 0 || subscriptionId == null) { return unresolved; }
                return Facts("id", "/subscriptions/" + subscriptionId, "subscriptionId", subscriptionId);
            case "resourceGroup":
                if (args.Count != 0 || resourceGroupName == null) { return unresolved; }
                var group = Facts("name", resourceGroupName);
                if (subscriptionId != null) { group["id"] = "/subscriptions/" + subscriptionId + "/resourceGroups/" + resourceGroupName; }
                return group;
            case "subscriptionResourceId":
                return ScopedId(args, false, subscriptionId, null);
            case "resourceId":
                return ScopedId(args, true, subscriptionId, resourceGroupName);
        }
        return unresolved;
    }

    // '/providers/<namespace>/<type>/<name>[/<child type>/<name>…]', one name per type segment after the namespace; null on a mismatch.
    public static string ProviderPath(object type, List<object> names)
    {
        if (!(type is string typeText) || !names.TrueForAll(n => n is string)) { return null; }
        string[] segments = typeText.Split('/');
        if (segments.Length != names.Count + 1 || Array.Exists(segments, string.IsNullOrEmpty)) { return null; }
        var id = new StringBuilder("/providers/").Append(segments[0]);
        for (int i = 1; i < segments.Length; i++) { id.Append('/').Append(segments[i]).Append('/').Append((string)names[i - 1]); }
        return id.ToString();
    }

    private static object ScopedId(List<object> args, bool atGroup, string subscriptionId, string resourceGroupName)
    {
        object unresolved = ArmExpression.Unresolved;
        if (!args.TrueForAll(a => a is string)) { return unresolved; }
        int type = args.FindIndex(a => ((string)a).IndexOf('/') >= 0);
        int scopeArguments = atGroup ? 2 : 1;
        if (type < 0 || type > scopeArguments) { return unresolved; }
        if (atGroup && type >= 1) { resourceGroupName = (string)args[type - 1]; }
        if (type == scopeArguments) { subscriptionId = (string)args[0]; }
        if (string.IsNullOrEmpty(subscriptionId) || (atGroup && string.IsNullOrEmpty(resourceGroupName))) { return unresolved; }
        string path = ProviderPath(args[type], args.GetRange(type + 1, args.Count - type - 1));
        if (path == null) { return unresolved; }
        string scope = "/subscriptions/" + subscriptionId + (atGroup ? "/resourceGroups/" + resourceGroupName : string.Empty);
        return scope + path;
    }

    // A fact the caller passes as a non-empty string; anything else, an Unresolved group name included, is no fact.
    private static string Fact(IDictionary deployment, string key)
    {
        if (deployment == null || !deployment.Contains(key)) { return null; }
        return deployment[key] is string value && value.Length > 0 ? value : null;
    }

    private static OrderedDictionary Facts(params string[] pairs)
    {
        var facts = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        for (int i = 0; i < pairs.Length; i += 2) { facts[pairs[i]] = pairs[i + 1]; }
        return facts;
    }
}
