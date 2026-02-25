import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// A GenUI [CatalogItem] that renders a horizontal carousel of product cards.
///
/// Demonstrates parent-child composition: the AI provides component IDs in
/// [items] and GenUI resolves them via [ItemContext.buildChild].
///
/// Schema properties:
/// - [title] — optional heading shown above the carousel
/// - [items] (required) — list of child component IDs (each must be a
///   ProductCard component defined in the same AI response)
final productCarouselItem = CatalogItem(
  name: 'ProductCarousel',
  dataSchema: Schema.object(
    description: 'A horizontally scrollable carousel of ProductCard children. '
        'Always populate the items array with the IDs of ProductCard '
        'components you have defined in the same response. '
        'Use this instead of listing products individually when showing '
        'multiple results.',
    properties: {
      'title': Schema.string(
        description: 'Optional heading displayed above the carousel, '
            'e.g. "Running Shoes for You".',
      ),
      'items': Schema.list(
        description:
            'Ordered list of child component IDs. Each ID must match a '
            'ProductCard component defined elsewhere in this response.',
        items: Schema.string(
          description: 'A component ID referencing a ProductCard.',
        ),
      ),
    },
    required: ['items'],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, Object?>;
    final context = itemContext.buildContext;
    final title = data['title'] as String?;
    final itemIds =
        (data['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Optional section heading
        if (title != null && title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        SizedBox(
          height: 360,
          child: itemIds.isEmpty
              ? const Center(child: Text('No products to display.'))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: itemIds.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final id = itemIds[index];
                    return SizedBox(
                      width: 220,
                      // buildChild resolves the component by ID and renders it
                      // using its registered CatalogItem widgetBuilder.
                      child: itemContext.buildChild(id),
                    );
                  },
                ),
        ),
      ],
    );
  },
);
