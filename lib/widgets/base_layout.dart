import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final bool isFloatingContainer;
  final Widget flexibleContainerChild;
  final Widget flexibleSpaceBarTitle;
  final List<Widget> slivers;
  final bool? isPinned;
  final Function onWillPop;
  final double? expandedHeight;
  final double? collapsedHeight;
  final double? radiusCircular;
  final Color? flexContainerColor;
  final Widget? floatingContainer;

  const BaseLayout({super.key,
  required this.onWillPop,
  required this.isFloatingContainer,
  required this.flexibleContainerChild,
  required this.flexibleSpaceBarTitle,
  required this.slivers,
  this.isPinned = true,
  this.expandedHeight = 190.0,
  this.collapsedHeight,
  this.radiusCircular = 25.0,
  this.flexContainerColor,
  this.floatingContainer,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> sliverWidgets = [
      SliverAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        snap: false,
        floating: true,
        pinned: isPinned!,
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        elevation: 0.0,
        flexibleSpace: FlexibleSpaceBar.createSettings(

          currentExtent: 0.0,
          child: FlexibleSpaceBar(
            background: Container(
              //padding: EdgeInsets.only(top: 90),
              decoration: BoxDecoration(
                  color: flexContainerColor??Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radiusCircular!),
                    bottomRight: Radius.circular(radiusCircular!),
                  )),
              child: flexibleContainerChild,
            ),
            title: flexibleSpaceBarTitle,
            centerTitle: true,
            //titlePadding: EdgeInsets.zero,
            //centerTitle:true
          ),
        ),

      ), ...slivers
    ];


    return CustomScrollView(
      slivers: sliverWidgets,
    );


  }
}
