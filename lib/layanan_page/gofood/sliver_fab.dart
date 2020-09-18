import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SliverContainer extends StatefulWidget {

 

  SliverContainer(
      {@required this.slivers,
      @required this.floatingActionButton,
      this.expandedHeight = 256.0,
      this.marginRight = 16.0,
      this.topScalingEdge = 96.0});

 final List<Widget> slivers;
  final Widget floatingActionButton;
  final double expandedHeight;
  final double marginRight;
  final double topScalingEdge;

  @override
  State<StatefulWidget> createState() {
    return   SliverFabState();
  }
}

class SliverFabState extends State<SliverContainer> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController =   ScrollController();
    scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return   Stack(
      children: <Widget>[

          CustomScrollView(
          controller: scrollController,
          slivers: widget.slivers,

        ),
        _buildFab(),

      ],
    );
  }

  Widget _buildFab() {
    final topMarginAdjustVal = Theme.of(context).platform == TargetPlatform.iOS ? 12.0 : -4.0;
    var   defaultTopMargin = widget.expandedHeight + topMarginAdjustVal;

    var top = defaultTopMargin;
    var scale = 1.0;
    if (scrollController.hasClients) {
      var offset = scrollController.offset;
      top -= offset > 0 ? offset : 0;
      if (offset < defaultTopMargin - widget.topScalingEdge) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - widget.topScalingEdge / 2) {
        scale = (defaultTopMargin - widget.topScalingEdge / 2 - offset) /
            (widget.topScalingEdge / 2);
      } else {
        scale = 0.0;
      }
    }

    return   Positioned(
      top: top,
      right: widget.marginRight,
      child:   Transform(
        transform:   Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        child: widget.floatingActionButton,
      ),
    );
  }
}