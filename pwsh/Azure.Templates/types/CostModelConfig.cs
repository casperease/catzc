// The cost model the estimate prices a compiled template by: each resource type's retail meter and monthly quantity; every default is declared once here ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Azure.Templates;

// One retail meter of a resource type: what the Retail Prices API names it, and how much of it one resource uses a month.
public sealed class CostMeter
{
    public string id { get; }
    public string type { get; }
    public string service { get; }
    public string meter { get; }
    public string product { get; }
    // The retail SKU the meter is read for, when one meter name is sold as several SKUs; empty matches any.
    public string sku { get; }
    public double quantity { get; }

    public CostMeter(string id, string type, string service, string meter, string product, string sku, double quantity)
    {
        this.id = id;
        this.type = type;
        this.service = service;
        this.meter = meter;
        this.product = product;
        this.sku = sku;
        this.quantity = quantity;
    }
}

public sealed class CostModelConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "cost-model configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "currency", "region", "headroom", "request_pause_ms", "meters" };
    private static readonly string[] MeterKeys = { "id", "type", "service", "meter", "product", "sku", "quantity" };
    private static readonly Regex Id = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$");

    // The currency the prices are read in.
    public string currency { get; } = "USD";

    // The Azure region the prices are read for, as the Retail Prices API names it.
    public string region { get; } = "westeurope";

    // How far above the estimate a budget sits: a budget amount must be at least the estimate times this factor.
    public double headroom { get; } = 1.2;

    // The pause between two Retail Prices API requests, in milliseconds, so a refresh stays under the service's rate limit.
    public int request_pause_ms { get; } = 1000;

    // The metered resource types; a type with no meter is free, or not yet modelled.
    public IReadOnlyList<CostMeter> meters { get; } = new CostMeter[0];

    public CostModelConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { raw = new Hashtable(); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        if (raw.Contains("currency"))
        {
            string value = raw["currency"] == null ? string.Empty : raw["currency"].ToString();
            if (!Regex.IsMatch(value, "^[A-Z]{3}$")) { errors.Add("currency must be a three-letter ISO code, such as USD"); }
            else { currency = value; }
        }
        if (raw.Contains("region"))
        {
            string value = raw["region"] == null ? string.Empty : raw["region"].ToString();
            if (!Regex.IsMatch(value, "^[a-z0-9]+$")) { errors.Add("region must be an Azure region name, such as westeurope"); }
            else { region = value; }
        }
        if (raw.Contains("headroom"))
        {
            double factor;
            if (Number(raw["headroom"], out factor) && factor >= 1) { headroom = factor; }
            else { errors.Add("headroom must be a number of at least 1"); }
        }
        if (raw.Contains("request_pause_ms"))
        {
            double pause;
            if (Number(raw["request_pause_ms"], out pause) && pause >= 0 && pause <= 60000 && pause == Math.Floor(pause)) { request_pause_ms = (int)pause; }
            else { errors.Add("request_pause_ms must be a whole number of milliseconds from 0 to 60000"); }
        }
        if (raw.Contains("meters"))
        {
            var list = new List<CostMeter>();
            var ids = new HashSet<string>(StringComparer.Ordinal);
            IEnumerable items = raw["meters"] as IEnumerable;
            if (items == null || raw["meters"] is string || raw["meters"] is IDictionary) { errors.Add("meters must be a list of meter entries"); }
            else
            {
                int index = 0;
                foreach (object item in items)
                {
                    index++;
                    IDictionary entry = item as IDictionary;
                    if (entry == null) { errors.Add(string.Format(CultureInfo.InvariantCulture, "meters[{0}] must be a mapping", index)); continue; }
                    foreach (object k in entry.Keys)
                    {
                        if (Array.IndexOf(MeterKeys, k == null ? null : k.ToString()) < 0)
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "meters[{0}]: unknown key '{1}' (allowed: {2})", index, k, string.Join(", ", MeterKeys)));
                        }
                    }
                    string id = Text(entry, "id");
                    string type = Text(entry, "type");
                    string service = Text(entry, "service");
                    string meter = Text(entry, "meter");
                    double quantity;
                    if (!Id.IsMatch(id)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "meters[{0}]: id '{1}' must be kebab-case", index, id)); }
                    else if (!ids.Add(id)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "meters[{0}]: id '{1}' is declared twice", index, id)); }
                    if (type.IndexOf('/') < 1) { errors.Add(string.Format(CultureInfo.InvariantCulture, "meters[{0}]: type '{1}' must be a resource type, such as Microsoft.KeyVault/vaults", index, type)); }
                    if (service.Length == 0 || meter.Length == 0) { errors.Add(string.Format(CultureInfo.InvariantCulture, "meters[{0}]: service and meter are required", index)); }
                    if (!Number(entry.Contains("quantity") ? entry["quantity"] : null, out quantity) || quantity <= 0)
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "meters[{0}]: quantity must be a positive number", index));
                    }
                    list.Add(new CostMeter(id, type, service, meter, Text(entry, "product"), Text(entry, "sku"), quantity));
                }
            }
            meters = list.ToArray();
        }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    // A number as YAML or a caller gives it: a boxed number converts as it is, a string parses in the invariant culture, never the machine's.
    private static bool Number(object value, out double number)
    {
        number = 0;
        if (value == null) { return false; }
        if (value is string text) { return double.TryParse(text, NumberStyles.Float, CultureInfo.InvariantCulture, out number); }
        if (value is IConvertible convertible)
        {
            try { number = convertible.ToDouble(CultureInfo.InvariantCulture); return true; }
            catch (FormatException) { return false; }
            catch (InvalidCastException) { return false; }
        }
        return false;
    }

    private static string Text(IDictionary entry, string key)
    {
        return entry.Contains(key) && entry[key] != null ? entry[key].ToString().Trim() : string.Empty;
    }
}
