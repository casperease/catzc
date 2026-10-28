// One retail meter of a resource type: what the Retail Prices API names it, and how much of it one resource uses a month.
namespace Catzc.Azure.Templates;

public sealed class CostMeter
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string id { get; }
    public string type { get; }
    public string service { get; }
    public string meter { get; }
    public string product { get; }
    // The retail SKU the meter is read for, when one meter name is sold as several SKUs; empty matches any.
    public string sku { get; }
    public double quantity { get; }
    // The region the Retail Prices API sells the meter in, when it is not the ARM region (a DNS billing zone, such as Zone 1); empty reads the model's region.
    public string region { get; }
    // The config SKU the meter prices: it applies only where the type's skus address resolves to this value; empty applies always.
    public string when_sku { get; }
    // How many of the type the meter prices, in place of the declarations counted, when a conditional declaration deploys fewer; 0 counts the declarations.
    public int count { get; }

    public CostMeter(string id, string type, string service, string meter, string product, string sku, double quantity, string region, string when_sku, int count)
    {
        this.id = id;
        this.type = type;
        this.service = service;
        this.meter = meter;
        this.product = product;
        this.sku = sku;
        this.quantity = quantity;
        this.region = region;
        this.when_sku = when_sku;
        this.count = count;
    }
}
