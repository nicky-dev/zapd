import '../events/event.dart';
import '../events/filter.dart';

/// Nostr subscription
class Subscription {
  final String id;
  final List<NostrFilter> filters;
  final Stream<NostrEvent> stream;
  final void Function() onClose;

  const Subscription({
    required this.id,
    required this.filters,
    required this.stream,
    required this.onClose,
  });

  /// Close subscription
  void close() {
    onClose();
  }

  @override
  String toString() => 'Subscription(id: $id, filters: ${filters.length})';
}
