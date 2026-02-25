import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// A GenUI [CatalogItem] that renders an interactive price range slider.
///
/// When the user taps "Apply Filter", a [UserActionEvent] named
/// `applyPriceFilter` is dispatched with the selected min/max values,
/// which flows back into the AI conversation for a new response.
///
/// Schema properties:
/// - [minPrice] (required) — absolute minimum of the range
/// - [maxPrice] (required) — absolute maximum of the range
/// - [currentMin] (required) — initial lower handle position
/// - [currentMax] (required) — initial upper handle position
final priceRangeFilterItem = CatalogItem(
  name: 'PriceRangeFilter',
  dataSchema: Schema.object(
    description: 'An interactive price-range filter with a dual-handle slider. '
        'Use this when the user wants to filter products by price. '
        'Set minPrice/maxPrice to cover the full range of available products '
        'and currentMin/currentMax to a sensible default selection.',
    properties: {
      'minPrice': Schema.number(
        description: 'The absolute minimum price in the range, e.g. 0.',
      ),
      'maxPrice': Schema.number(
        description: 'The absolute maximum price in the range, e.g. 300.',
      ),
      'currentMin': Schema.number(
        description: 'Initial lower-handle value; must be ≥ minPrice.',
      ),
      'currentMax': Schema.number(
        description: 'Initial upper-handle value; must be ≤ maxPrice.',
      ),
    },
    required: ['minPrice', 'maxPrice', 'currentMin', 'currentMax'],
  ),
  widgetBuilder: (itemContext) {
    final data = itemContext.data as Map<String, Object?>;
    final minPrice = (data['minPrice'] as num?)?.toDouble() ?? 0.0;
    final maxPrice = (data['maxPrice'] as num?)?.toDouble() ?? 500.0;
    final currentMin = (data['currentMin'] as num?)?.toDouble() ?? minPrice;
    final currentMax = (data['currentMax'] as num?)?.toDouble() ?? maxPrice;

    return _PriceRangeFilter(
      minPrice: minPrice,
      maxPrice: maxPrice,
      initialMin: currentMin.clamp(minPrice, maxPrice),
      initialMax: currentMax.clamp(minPrice, maxPrice),
      itemContext: itemContext,
    );
  },
);

class _PriceRangeFilter extends StatefulWidget {
  const _PriceRangeFilter({
    required this.minPrice,
    required this.maxPrice,
    required this.initialMin,
    required this.initialMax,
    required this.itemContext,
  });

  final double minPrice;
  final double maxPrice;
  final double initialMin;
  final double initialMax;
  final CatalogItemContext itemContext;

  @override
  State<_PriceRangeFilter> createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends State<_PriceRangeFilter> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(widget.initialMin, widget.initialMax);
  }

  void _applyFilter() {
    widget.itemContext.dispatchEvent(
      UserActionEvent(
        name: 'applyPriceFilter',
        sourceComponentId: widget.itemContext.id,
        context: {
          'minPrice': _values.start,
          'maxPrice': _values.end,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.tune, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Filter by Price',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${_values.start.toStringAsFixed(0)} '
              '– '
              '\$${_values.end.toStringAsFixed(0)}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            RangeSlider(
              values: _values,
              min: widget.minPrice,
              max: widget.maxPrice,
              divisions: ((widget.maxPrice - widget.minPrice) / 5)
                  .round()
                  .clamp(1, 200),
              labels: RangeLabels(
                '\$${_values.start.toStringAsFixed(0)}',
                '\$${_values.end.toStringAsFixed(0)}',
              ),
              onChanged: (values) => setState(() => _values = values),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${widget.minPrice.toStringAsFixed(0)}',
                      style: theme.textTheme.labelSmall),
                  Text('\$${widget.maxPrice.toStringAsFixed(0)}',
                      style: theme.textTheme.labelSmall),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _applyFilter,
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Apply Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
