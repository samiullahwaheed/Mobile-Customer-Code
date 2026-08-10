import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loyalty_customer/utils/app_size.dart';

/// Infinite auto-scrolling horizontal carousel.
/// Scrolls right-to-left continuously with seamless loop (no visible reset).
class AutoScrollRewardCarousel extends StatefulWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final double? itemWidth;
  final double itemSpacing;
  final Duration autoScrollInterval;
  final double? scrollAmount;

  const AutoScrollRewardCarousel({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.itemWidth,
    this.itemSpacing = 12,
    this.autoScrollInterval = const Duration(seconds: 3),
    this.scrollAmount,
  });

  @override
  State<AutoScrollRewardCarousel> createState() =>
      _AutoScrollRewardCarouselState();
}

class _AutoScrollRewardCarouselState extends State<AutoScrollRewardCarousel> {
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  static const int _repeatCount = 3; // Duplicate list for seamless infinite loop

  double get _effectiveItemWidth =>
      widget.itemWidth ?? (AppSize.size.width * 0.8 + widget.itemSpacing);

  double get _effectiveScrollAmount {
    final amount = widget.scrollAmount;
    return amount != null ? amount : _effectiveItemWidth;
  }

  /// Width of one full set of items (one "loop")
  double get _loopWidth =>
      widget.itemCount * _effectiveItemWidth;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _onScroll() {
    if (!_scrollController.hasClients || widget.itemCount <= 0) return;

    final offset = _scrollController.offset;
    // When we've scrolled past one loop, jump back by one loop – content is
    // identical so user sees no reset
    if (offset >= _loopWidth) {
      _scrollController.jumpTo(offset - _loopWidth);
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(widget.autoScrollInterval, (_) {
      if (!_scrollController.hasClients || widget.itemCount <= 0) return;

      final targetOffset = _scrollController.offset + _effectiveScrollAmount;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) return const SizedBox.shrink();

    final displayCount = widget.itemCount * _repeatCount;

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: displayCount,
      itemBuilder: (context, index) {
        final realIndex = index % widget.itemCount;
        return widget.itemBuilder(context, realIndex);
      },
    );
  }
}
