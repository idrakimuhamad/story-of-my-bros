import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'model/product.dart';

import 'login.dart';

// motion velocity
const double _velocity = 2.0;

class Backdrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  // constructor
  Backdrop({
    @required this.currentCategory,
    @required this.frontLayer,
    @required this.backLayer,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(currentCategory != null),
        assert(frontLayer != null),
        assert(backLayer != null),
        assert(frontTitle != null),
        assert(backTitle != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({Key key, this.child, this.onTap}) : super(key: key);

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 18.0,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(46.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child:
                Container(height: 40.0, alignment: AlignmentDirectional.center),
          ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  // TODO: Add AnimationController widget (104)
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: Duration(milliseconds: 300), value: 1.0, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;

    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(velocity: _frontLayerVisible ? -_velocity : _velocity);
  }

  // TODO: Add BuildContext and BoxConstraints parameters to _buildStack (104)
  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;

    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
            begin: RelativeRect.fromLTRB(
                0.0, layerTop, 0.0, layerTop - layerSize.height),
            end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(_controller.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _frontLayerVisible,
        ),
        PositionedTransition(
          child: _FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            child: widget.frontLayer,
          ),
          rect: layerAnimation,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      brightness: Brightness.dark,
      title: _BackdropTitle(
        listenable: _controller.view,
        onPress: _toggleBackdropLayerVisibility,
        frontTitle: widget.frontTitle,
        backTitle: widget.backTitle,
      ),
      // leading: IconButton(
      //   icon: Icon(
      //     Icons.menu,
      //     semanticLabel: "menu",
      //   ),
      //   onPressed: _toggleBackdropLayerVisibility,
      // ),
      actions: <Widget>[
        IconButton(
            onPressed: () {
              // TODO: Add open login (104)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
            },
            icon: Icon(
              Icons.search,
              semanticLabel: 'login',
            )),
        IconButton(
          onPressed: () {
            // TODO: Add open login (104)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()));
          },
          icon: Icon(
            Icons.tune,
            semanticLabel: 'filter',
          ),
        )
      ],
    );

    return Scaffold(appBar: appBar, body: LayoutBuilder(builder: _buildStack));
  }

  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);

    if (widget.currentCategory != old.currentCategory) {
      _toggleBackdropLayerVisibility();
    } else if (!_frontLayerVisible) {
      _controller.fling(velocity: _velocity);
    }
  }
}

class _BackdropTitle extends AnimatedWidget {
  final Function onPress;
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle(
      {Key key,
      Listenable listenable,
      this.onPress,
      @required this.frontTitle,
      @required this.backTitle})
      : assert(frontTitle != null),
        assert(backTitle != null),
        super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;

    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(
        children: <Widget>[
          SizedBox(
              width: 72.0,
              child: IconButton(
                padding: EdgeInsets.only(right: 8.0),
                onPressed: this.onPress,
                icon: Stack(children: <Widget>[
                  Opacity(
                      opacity: animation.value,
                      child: ImageIcon(AssetImage('assets/slanted_menu.png'))),
                  FractionalTranslation(
                    translation:
                        Tween<Offset>(begin: Offset.zero, end: Offset(1.0, 0.0))
                            .evaluate(animation),
                    child: ImageIcon(AssetImage('assets/diamond.png')),
                  )
                ]),
              )),
          Stack(
            children: <Widget>[
              Opacity(
                opacity: CurvedAnimation(
                        curve: Interval(0.5, 1.0),
                        parent: ReverseAnimation(animation))
                    .value,
                child: FractionalTranslation(
                    translation:
                        Tween<Offset>(begin: Offset.zero, end: Offset(0.5, 0.0))
                            .evaluate(animation),
                    child: backTitle),
              ),
              Opacity(
                opacity: CurvedAnimation(
                        curve: Interval(0.5, 1.0), parent: animation)
                    .value,
                child: FractionalTranslation(
                    translation: Tween<Offset>(
                            begin: Offset(-0.25, .0), end: Offset.zero)
                        .evaluate(animation),
                    child: frontTitle),
              )
            ],
          )
        ],
      ),
    );
  }
}
