# NIP-XX: Food Delivery Extension for Marketplace

## Abstract

This NIP extends NIP-15 (Marketplace) to support food delivery and real-time ordering systems on the Nostr protocol.

## Motivation

While NIP-15 provides a solid foundation for e-commerce marketplaces, food delivery requires additional features:

- Real-time order status updates
- Location-based delivery zones
- Time-sensitive operations (preparation time, delivery ETA)
- Enhanced privacy for delivery addresses
- Rider assignment and coordination

## Specification

### Stall Types

Add `stall_type` tag to kind 30017 events:

- `food`: Restaurant/Food stall
- `shop`: Retail/Mart/Grocery

### Additional Stall Metadata for Food Delivery

#### Kind 30017 (Stall) Extensions

```json
{
	"kind": 30017,
	"pubkey": "<merchant-pubkey>",
	"tags": [
		["d", "<stall-id>"],
		["stall_type", "food"],
		["cuisine", "thai"],
		["accepts_orders", "true"],
		["preparation_time", "30"],
		["operating_hours", "09:00-22:00"],
		["location_encrypted", "<nip44-encrypted-address>"],
		["delivery_zone", "<geohash-precision-6>"],
		["min_order", "100"],
		["delivery_fee", "50"],
		["payment_method", "ln"],
		["shipping_method", "delivery"]
	],
	"content": "{\"name\":\"Thai Street Food\",\"description\":\"Authentic Thai cuisine\",\"images\":[\"https://...\"],\"currency\":\"BTC\"}"
}
```

**New Tags:**

- `stall_type`: Type of stall (food/shop)
- `cuisine`: Cuisine type for food stalls (thai, italian, japanese, etc.)
- `accepts_orders`: Whether the stall is currently accepting orders (true/false)
- `preparation_time`: Average preparation time in minutes
- `operating_hours`: Operating hours in format "HH:MM-HH:MM"
- `location_encrypted`: NIP-44 encrypted exact location for merchant/rider
- `location_encrypted`: NIP-44 encrypted exact location for merchant/rider
- `g`: High-precision geohash (precision 12) for exact merchant location. Use `['g', '<geohash-12>']` when publishing the merchant's precise coordinates so relays and clients can index and filter by exact location.
- `delivery_zone`: Geohash (precision 6-7) for public delivery coverage (multiple tags allowed)
- `min_order`: Minimum order amount in satoshis or smallest currency unit
- `delivery_fee`: Delivery fee in satoshis or smallest currency unit

### Product Extensions for Food

#### Kind 30018 (Product) Extensions

```json
{
	"kind": 30018,
	"pubkey": "<merchant-pubkey>",
	"tags": [
		["d", "<product-id>"],
		// Include the canonical 'a' composite tag so relays and clients can filter by stall using '#a'
		// Format: "<kind>:<merchant-pubkey>:<id>" e.g. "30017:npub1...:stall_01"
		["a", "30017:<merchant-pubkey>:<stall-id>"],
		["category", "main-dish"],
		["spicy_level", "2"],
		["preparation_time", "15"],
		["available", "true"],
		["daily_limit", "50"],
		["customization", "<nip44-encrypted-options>"]
	],
	"content": "{\"id\":\"<product-id>\",\"stall_id\":\"<stall-id>\",\"name\":\"Pad Thai\",\"description\":\"...\",\"images\":[...],\"currency\":\"BTC\",\"price\":100}"
}
```

**New Tags:**

- `a`: Canonical composite reference used for indexing/filtering by resource. Format: `['a','<kind>:<pubkey>:<id>']`. Clients/relays can subscribe with `"#a": ["30017:<merchant-pubkey>:<stall-id>"]` to receive products for that stall.
- `category`: Product category (appetizer, main-dish, dessert, beverage, etc.)
- `spicy_level`: Spiciness level 0-5 (0=not spicy, 5=very spicy)
- `preparation_time`: Item-specific preparation time in minutes
- `available`: Current availability (true/false)
- `daily_limit`: Maximum units available per day
- `customization`: NIP-44 encrypted customization options (size, toppings, etc.)

**Operational Tags**

- `o`: Open/closed quick flag. Use `['o','open']` or `['o','closed']` to let relays index currently-open stalls. Semantics recommended: `open` when merchant `accepts_orders == true` and (optionally) current time falls within `operating_hours`.

Note: keep `stall_id` inside the JSON `content` for explicit referencing by clients that parse content. The `s` tag is primarily for relay-side indexing and fast subscription filtering.

### Backfill / Migration Strategy

If you already have existing product events that include `stall_id` only in the `content` and not the canonical `a` tag, relays won't be able to index them by `#a`. To migrate:

1. Build a backfill script (careful: this will republish events):
   - Subscribe to existing product events (kind 30018) from your merchant pubkey.

- For each event that has a `content` with a `stall_id` but no `a` tag, publish a replacement event with the same `d` tag (product id) and identical content but including the `a` composite tag (e.g. `['a','30017:<merchant-pubkey>:<stall-id>']`). Use the same author/merchant key and a newer timestamp so the replacement becomes the latest version.

2. Because kind 30018 is treated as parameterized replaceable by `d`, publishing a new event with the same `d` and higher `created_at` will replace the previous one for most clients.
3. Take care with rate limits and relay load — run the backfill in small batches, and consider contacting relay operators if you expect a large replay.

Example filter to fetch products for a stall after migration:

```json
{
	"kinds": [30018],
	"#a": ["30017:<merchant-pubkey>:<stall-id>"],
	"limit": 200
}
```

This will return product events that include the `s` tag with the given stall id.

## Order Management

### Order Status Tracking (kind 30078)

Public order status using Parameterized Replaceable Events:

```json
{
	"kind": 30078,
	"pubkey": "<customer-pubkey>",
	"tags": [
		["d", "<order-id>"],
		["order_type", "food_delivery"],
		["a", "30017:<merchant-pubkey>:<stall-id>"],
		["p", "<merchant-pubkey>"],
		["status", "pending"],
		["created_at_timestamp", "1699564800"]
	],
	"content": ""
}
```

**Order Status Values:**

- `pending`: Order placed, waiting for merchant acceptance
- `accepted`: Merchant accepted the order
- `preparing`: Food is being prepared
- `ready`: Order is ready for pickup
- `delivering`: Rider is delivering
- `completed`: Order delivered successfully
- `cancelled`: Order was cancelled

**Short status tag (single-letter)**

- `s`: Short alias for `status`. Use `['s', '<state>']` for relay-friendly, single-character indexing. Example: `['s', 'preparing']` and filter with `"#s": ["preparing"]`.

### Order Details (kind 14 - NIP-44 Encrypted DM)

Private order details sent to merchant:

```json
{
  "kind": 14,
  "pubkey": "<customer-pubkey>",
  "tags": [
    ["p", "<merchant-pubkey>"],
    ["order_id", "<order-id>"],
    ["e", "<order-status-event-id>"]
  ],
  "content": "<nip44-encrypted>({
    \"items\": [
      {
        \"product_id\": \"prod-123\",
        \"quantity\": 2,
        \"customization\": {\"size\": \"large\", \"extra\": [\"cheese\"]},
        \"price\": 100
      }
    ],
    \"delivery_address\": {
      \"street\": \"123 Main St\",
      \"city\": \"Bangkok\",
      \"postcode\": \"10110\",
      \"lat\": 13.7563,
      \"lon\": 100.5018
    },
    \"phone\": \"+66812345678\",
    \"special_instructions\": \"No cilantro please\",
    \"payment_hash\": \"<lightning-payment-hash>\",
    \"payment_preimage\": \"<payment-preimage>\",
    \"total\": 250
  })"
}
```

### Order Status Updates

Merchant updates status by publishing a new version of the kind 30078 event:

```json
{
	"kind": 30078,
	"pubkey": "<customer-pubkey>",
	"tags": [
		["d", "<order-id>"],
		["status", "preparing"],
		["updated_at", "1699565400"],
		["estimated_ready", "1699566200"]
	],
	"content": ""
}
```

### Rider Assignment (kind 14 - NIP-44 Encrypted)

Merchant assigns rider privately:

```json
{
  "kind": 14,
  "pubkey": "<merchant-pubkey>",
  "tags": [
    ["p", "<rider-pubkey>"],
    ["order_id", "<order-id>"]
  ],
  "content": "<nip44-encrypted>({
    \"pickup_location\": {
      \"name\": \"Thai Street Food\",
      \"address\": \"456 Restaurant Ave\",
      \"lat\": 13.7500,
      \"lon\": 100.5000,
      \"phone\": \"+66823456789\"
    },
    \"delivery_location\": {
      \"address\": \"123 Main St\",
      \"lat\": 13.7563,
      \"lon\": 100.5018,
      \"phone_encrypted\": \"<encrypted-customer-phone>\"
    },
    \"delivery_fee\": 50,
    \"customer_name\": \"John D.\",
    \"order_summary\": \"2 items, Paid\"
  })"
}
```

## Real-time Subscriptions

### Merchant Subscriptions

Merchants should subscribe to:

```json
{
	"kinds": [14, 30078],
	"#p": ["<merchant-pubkey>"]
}
```

### Customer Subscriptions

Customers track their orders:

```json
{
	"kinds": [30078],
	"authors": ["<customer-pubkey>"],
	"#d": ["<order-id>"]
}
```

### Rider Subscriptions

Riders receive assignments:

```json
{
	"kinds": [14],
	"#p": ["<rider-pubkey>"]
}
```

## Payment Flow

1. **Order Creation**: Customer browses stalls and products
2. **Lightning Invoice**: Customer generates Lightning invoice (NIP-57)
3. **Payment Proof**: Customer pays and receives preimage
4. **Order Submission**: Customer publishes kind 30078 (status: pending) and kind 14 (encrypted details with payment proof)
5. **Merchant Verification**: Merchant verifies payment and accepts/rejects order
6. **Status Updates**: Merchant updates kind 30078 as order progresses
7. **Rider Assignment**: Merchant assigns rider via kind 14
8. **Delivery**: Rider updates location and completes delivery
9. **Completion**: Final status update to "completed"

## Location Privacy

- **Public Delivery Zones**: Use geohash (precision 6-7) in stall events for approximate coverage area
- **Private Addresses**: Always encrypt exact addresses using NIP-44
- **Geohash Precision Guide**:
  - Precision 6: ~1.2km × 609m (for delivery zone advertising)
  - Precision 7: ~153m × 153m (for tighter zones)
- **Never expose**: Exact coordinates in public events

## Security Considerations

1. **Payment Verification**: Always verify Lightning payment preimage before accepting orders
2. **Address Encryption**: Use NIP-44 for all personal information (addresses, phone numbers)
3. **Relay Authentication**: Use NIP-42 for authenticated relay connections
4. **Rate Limiting**: Implement relay-level rate limiting to prevent spam orders
5. **Reputation System**: Consider implementing NIP-58 (Badges) for merchant/rider reputation

## Implementation Notes

- Use NIP-44 (not deprecated NIP-04) for all encryption
- Parameterized Replaceable Events (kind 30078) allow efficient order status updates
- Merchants can manage multiple stalls with different `d` tags
- Products reference their stall via `stall_id` tag
- Consider implementing offline-first approach with local caching

## Examples

See implementation in ZapD reference application:

- Merchant app: Flutter web/desktop for stall and product management
- Customer app: Flutter mobile/web for browsing and ordering
- Rider app: Flutter mobile for delivery management

## References

- [NIP-01: Basic Protocol](https://github.com/nostr-protocol/nips/blob/master/01.md)
- [NIP-15: Marketplace](https://github.com/nostr-protocol/nips/blob/master/15.md)
- [NIP-44: Encrypted Payloads](https://github.com/nostr-protocol/nips/blob/master/44.md)
- [NIP-57: Lightning Zaps](https://github.com/nostr-protocol/nips/blob/master/57.md)
- [NIP-42: Authentication](https://github.com/nostr-protocol/nips/blob/master/42.md)

## License

Public Domain
