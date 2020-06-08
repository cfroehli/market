module Market
  module Pricer
    TAX_RATE = 0.08
    PACKAGING_FEES_LADDER = [
      [100000, 1000],
      [30000,  600],
      [10000,  400],
      [0, 300],
    ].freeze

    def self.hashgetter(key)
      ->(hash) { hash[key] }
    end

    def self.compute_items_pricing(items)
      Product.find(items.map { |id, _| id }).map do |product|
        id = product.id
        quantity = items[id.to_s]
        unit_price = product.price
        { id: id, name: product.name, qty: quantity,
          unit_price: unit_price, price: quantity * unit_price }
      end
    end

    def self.compute_packaging_fees(total_value)
      packaging_fees = ::Market::Pricer::PACKAGING_FEES_LADDER.find { |fees| fees[0] <= total_value }[1]
      { name: 'Packaging fees', qty: nil, price: packaging_fees }
    end

    def self.compute_shipping_fees(items_pricing)
      items_count = items_pricing.sum(&hashgetter(:quantity))
      shipping_fees = ((items_count / 5) + 1) * 600 # cost = 600 per batch of 5 articles
      { name: 'Shipping fees', qty: nil, price: shipping_fees }
    end

    def self.compute_full_pricing(items_pricing)
      total_value = items_pricing.sum(&hashgetter(:price))
      packaging_fees_detail = compute_packaging_fees(total_value)
      shipping_fees_detail = compute_shipping_fees(items_pricing)
      total = total_value + packaging_fees_detail[:price] + shipping_fees_detail[:price]
      total_tax_included = total + (total * ::Market::Pricer::TAX_RATE).floor
      [
        *items_pricing,
        packaging_fees_detail,
        shipping_fees_detail,
        { name: 'Total (tax inc.)', qty: nil, price: total_tax_included },
      ]
    end

    def self.price(items)
      # TODO: we'll probably want reliable monotonic timestamps instead
      pricing_start = Time.zone.now
      items_pricing = compute_items_pricing(items)
      pricing_detail = compute_full_pricing(items_pricing)
      pricing_end = Time.zone.now
      {
        metadata: {
          pricing_start: pricing_start,
          pricing_end: pricing_end,
        },
        detail: pricing_detail,
      }
    end
  end
end
