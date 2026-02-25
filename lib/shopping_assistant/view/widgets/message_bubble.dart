import 'package:flutter/material.dart';

/// The visual role of a message bubble.
enum BubbleRole { user, assistant, error }

/// A chat bubble for user messages, assistant text, or error notices.
///
/// - [user] — right-aligned, [ColorScheme.primaryContainer] background
/// - [assistant] — left-aligned, [ColorScheme.surfaceContainerHighest]
/// - [error] — left-aligned, [ColorScheme.errorContainer]
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.role,
  });

  final String text;
  final BubbleRole role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = role == BubbleRole.user;
    final isError = role == BubbleRole.error;

    final Color backgroundColor;
    final Color foregroundColor;

    if (isUser) {
      backgroundColor = theme.colorScheme.primaryContainer;
      foregroundColor = theme.colorScheme.onPrimaryContainer;
    } else if (isError) {
      backgroundColor = theme.colorScheme.errorContainer;
      foregroundColor = theme.colorScheme.onErrorContainer;
    } else {
      backgroundColor = theme.colorScheme.surfaceContainerHighest;
      foregroundColor = theme.colorScheme.onSurface;
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isUser ? 48 : 16,
          right: isUser ? 16 : 48,
          top: 4,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isError) ...[
              Icon(Icons.error_outline,
                  size: 16, color: theme.colorScheme.error),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: foregroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
