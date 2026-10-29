using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace Catzc.Azure.Templates;

// The one renderer of an Azure resource name: the namer and the matcher both render through it, so a name has one canonical form.
public static class AzureNameRenderer
{
    // Renders the name and holds it to the limit, throwing when the type has no limit or the name exceeds it.
    public static string Render(IDictionary components, IEnumerable order, IDictionary typeSpec, IDictionary pattern)
    {
        int limit = Limit(components, typeSpec, pattern);
        string name = Join(components, order, typeSpec, pattern);
        if (name.Length > limit)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "Resource name '{0}' ({1} chars) exceeds the '{2}' limit of {3} — shorten short_name / slot / customer / role.",
                name, name.Length, Value(components, "type"), limit));
        }
        return name;
    }

    // Each segment fuses its present components; a component the type omits or that is empty is skipped, and an empty segment is dropped.
    public static string Join(IDictionary components, IEnumerable order, IDictionary typeSpec, IDictionary pattern)
    {
        if (components == null) { throw new ArgumentNullException(nameof(components)); }
        if (order == null) { throw new ArgumentNullException(nameof(order)); }
        if (typeSpec == null) { throw new ArgumentNullException(nameof(typeSpec)); }
        if (pattern == null) { throw new ArgumentNullException(nameof(pattern)); }
        List<string> omit = Omit(typeSpec);
        List<string> segments = new List<string>();
        foreach (object segment in order)
        {
            IEnumerable members = segment is string single ? new[] { single } : segment as IEnumerable;
            if (members == null) { continue; }
            StringBuilder fused = new StringBuilder();
            foreach (object member in members)
            {
                string component = member == null ? string.Empty : member.ToString();
                if (omit.Contains(component)) { continue; }
                fused.Append(Value(components, component));
            }
            if (fused.Length > 0) { segments.Add(fused.ToString()); }
        }
        string separator = pattern.Contains("separator") && pattern["separator"] != null ? pattern["separator"].ToString() : string.Empty;
        return string.Join(separator, segments);
    }

    // The limit is the pattern's intrinsic cap (kv/storage/vm) or, for a pattern without one, the type's own.
    public static int Limit(IDictionary components, IDictionary typeSpec, IDictionary pattern)
    {
        if (typeSpec == null) { throw new ArgumentNullException(nameof(typeSpec)); }
        if (pattern == null) { throw new ArgumentNullException(nameof(pattern)); }
        if (pattern.Contains("limit") && pattern["limit"] != null) { return Convert.ToInt32(pattern["limit"], CultureInfo.InvariantCulture); }
        if (typeSpec.Contains("limit") && typeSpec["limit"] != null) { return Convert.ToInt32(typeSpec["limit"], CultureInfo.InvariantCulture); }
        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "Type '{0}' (pattern '{1}') has no length limit",
            Value(components, "type"), typeSpec.Contains("pattern") ? typeSpec["pattern"] : null));
    }

    // The components the type omits from its render: the namer, the matcher and Join all read them here; a scalar omit counts as none.
    public static List<string> Omit(IDictionary typeSpec)
    {
        if (typeSpec == null) { throw new ArgumentNullException(nameof(typeSpec)); }
        List<string> omit = new List<string>();
        if (typeSpec.Contains("omit") && typeSpec["omit"] is IEnumerable list && !(typeSpec["omit"] is string))
        {
            foreach (object item in list)
            {
                if (item != null) { omit.Add(item.ToString()); }
            }
        }
        return omit;
    }

    // The one form rule of env and customer: the generous long pattern renders the readable value, every restricted pattern the shortcode.
    public static string ComponentForm(string patternName, string readable, string shortcode)
    {
        return patternName == "long" ? readable : shortcode;
    }

    private static string Value(IDictionary components, string component)
    {
        if (components == null || !components.Contains(component) || components[component] == null) { return string.Empty; }
        return components[component].ToString();
    }
}
