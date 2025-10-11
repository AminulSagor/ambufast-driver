// lib/models/page_result.dart
class PageResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;

  const PageResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  bool get hasMore => items.length + (page - 1) * pageSize < totalCount;
}
