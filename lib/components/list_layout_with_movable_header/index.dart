import 'package:flutter/material.dart';
import 'package:moegirl_viewer/utils/status_bar_height.dart';

class ListLayoutWithMovableHeader extends StatefulWidget {
  final double maxDistance;
  final bool statusBarMask;  // 为状态栏区域添加一个遮罩，防止header上移时header的文字和状态栏文字重叠
  final ScrollController scrollController;
  final Widget header;
  final Widget Function(bool headerFloated) listBuilder;

  ListLayoutWithMovableHeader({
    @required this.maxDistance,
    this.statusBarMask = true,
    @required this.scrollController,
    @required this.header,
    @required this.listBuilder,
    Key key
  }) : super(key: key);

  @override
  _ListLayoutWithMovableHeaderState createState() => _ListLayoutWithMovableHeaderState();
}

// 这个组件原理是将在滚动位置为0时，在顶部显示一个固定头部
// 在滚动位置非0时，将顶部固定头部去掉，展示一个定位的头部，并对列表添加额外的顶部padding
// 这样做是为了在实现活动头部的同时，下拉刷新还可以正常工作
// 如果一直使用定位头部，会导致下拉刷新的指示器被定位头部遮挡
class _ListLayoutWithMovableHeaderState extends State<ListLayoutWithMovableHeader> {
  bool headerFloated = false;
  
  @override
  void initState() { 
    super.initState();
    widget.scrollController.addListener(scrollListener);
  }

  @override
  void dispose() { 
    widget.scrollController.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    // offset为0或非0有变化时再设置，防止频繁setState
    final headerFloated = widget.scrollController.offset != 0;
    if (this.headerFloated != headerFloated) {
      setState(() => this.headerFloated = headerFloated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        if (!headerFloated) widget.header,
        Expanded(
          child: Stack(
            children: [
              widget.listBuilder(headerFloated),
              if (headerFloated) (
                _PositionedHeader(
                  maxDistance: widget.maxDistance,
                  scrollController: widget.scrollController,
                  header: widget.header,
                )
              ),

              if (widget.statusBarMask && headerFloated) (
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: statusBarHeight,
                    color: theme.primaryColor,
                  )
                )
              )
            ],
          )
        )
      ],
    );
  }
}

// 将PositionedHeader单独拆出来，防止每次更新positionTop时整个列表跟着一起更新
class _PositionedHeader extends StatefulWidget {
  final double maxDistance;
  final ScrollController scrollController;
  final Widget header;
  
  _PositionedHeader({
    @required this.maxDistance,
    @required this.scrollController,
    @required this.header,
    Key key
  }) : super(key: key);

  @override
  _PositionedHeaderState createState() => _PositionedHeaderState();
}

class _PositionedHeaderState extends State<_PositionedHeader> {
  double positionTop = 0;
  double lastOffset = 0;
  
  @override
  void initState() { 
    super.initState();
    widget.scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    final movingValue = widget.scrollController.offset - lastOffset;
    var newPositionTop = positionTop - movingValue;
    if (newPositionTop < -widget.maxDistance) newPositionTop = -widget.maxDistance;
    if (newPositionTop > 0) newPositionTop = 0;
    setState(() => positionTop = newPositionTop);
    
    lastOffset = widget.scrollController.offset;
  }
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: positionTop,
      left: 0,
      width: MediaQuery.of(context).size.width,
      child: widget.header,
    );
  }
}