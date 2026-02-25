import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// A GenUI [CatalogItem] that renders an individual product card.
///
/// Schema properties:
/// - [productName] (required) — display name of the product
/// - [price] (required) — price as a number (USD)
/// - [description] (required) — short product description
/// - [brand] — brand or manufacturer name
/// - [imageUrl] — URL for the product image
/// - [rating] — numeric rating 0–5
final productCardItem = CatalogItem(
  name: 'ProductCard',
  dataSchema: Schema.object(
    description:
        'An individual product card showing name, price, image, and rating. '
        'Use this for a single product or as a child inside a ProductCarousel.',
    properties: {
      'productName': Schema.string(
        description: 'The full display name of the product.',
      ),
      'price': Schema.number(
        description: 'Product price in USD as a decimal number, e.g. 79.99.',
      ),
      'description': Schema.string(
        description: 'A concise 1-2 sentence description of the product.',
      ),
      'brand': Schema.string(
        description: 'Brand or manufacturer name.',
      ),
      'imageUrl': Schema.string(
        description:
            'A direct URL to a product image. Use a real plausible URL or '
            'omit this field entirely — do not fabricate URLs.',
      ),
      'rating': Schema.number(
        description: 'Numeric rating from 0 to 5, e.g. 4.3.',
      ),
    },
    required: ['productName', 'price', 'description'],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, Object?>;
    final context = itemContext.buildContext;
    final productName = data['productName'] as String? ?? 'Product';
    final price = (data['price'] as num?)?.toDouble() ?? 0.0;
    final description = data['description'] as String? ?? '';
    final brand = data['brand'] as String?;
    final imageUrl = data['imageUrl'] as String?;
    final rating = (data['rating'] as num?)?.toDouble();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child:
                      const Icon(Icons.image_not_supported_outlined, size: 48),
                ),
              )
            else
              Container(
                height: 140,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.shopping_bag, size: 48)),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand label
                  if (brand != null)
                    Text(
                      brand.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.8,
                          ),
                    ),

                  const SizedBox(height: 4),

                  // Product name
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '\$${price.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      if (rating != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => itemContext.dispatchEvent(
                        UserActionEvent(
                          name: 'addToCart',
                          sourceComponentId: itemContext.id,
                          context: {'productName': productName, 'price': price},
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
);
