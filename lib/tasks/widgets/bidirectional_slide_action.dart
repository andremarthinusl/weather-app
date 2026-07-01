import 'package:flutter/material.dart';

class BidirectionalSlideAction extends StatefulWidget {
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;
  
  const BidirectionalSlideAction({
    super.key,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  @override
  State<BidirectionalSlideAction> createState() => _BidirectionalSlideActionState();
}

class _BidirectionalSlideActionState extends State<BidirectionalSlideAction> {
  double _position = 0.0;
  bool _isDragging = false;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        const thumbWidth = 64.0;
        final maxDragDistance = (maxWidth / 2) - (thumbWidth / 2) - 4;

        return Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Stack(
            children: [
              // Background indicators
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.delete_outline, color: Colors.redAccent.withValues(alpha: _position < 0 ? 1 : 0.5)),
                    ),
                    const Text(
                      '<<< Cancel   |   Complete >>>',
                      style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.check_circle_outline, color: Colors.greenAccent.withValues(alpha: _position > 0 ? 1 : 0.5)),
                    ),
                  ],
                ),
              ),
              
              // The Thumb
              AnimatedPositioned(
                duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                left: (maxWidth / 2) - (thumbWidth / 2) + _position,
                top: 4,
                bottom: 4,
                width: thumbWidth,
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _position += details.delta.dx;
                      if (_position > maxDragDistance) _position = maxDragDistance;
                      if (_position < -maxDragDistance) _position = -maxDragDistance;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      _isDragging = false;
                    });
                    
                    if (_position > maxDragDistance * 0.75) {
                      widget.onSwipeRight();
                    } else if (_position < -maxDragDistance * 0.75) {
                      widget.onSwipeLeft();
                    }
                    
                    setState(() {
                      _position = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.swipe_rounded, color: Color(0xFF2C3E50), size: 28),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
