import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A customizable AppBar widget for a global application bar.
///
/// The [GlobalAppBar] class extends Flutter's [AppBar] to provide a reusable
/// and configurable application bar that can be used across the application.
///
/// It allows for optional leading and action widgets with respective callbacks.
/// If no leading callback is provided, a default back button is displayed which
/// pops the current route using [GoRouter].
///
/// The app bar also includes a centrally-aligned title with a custom image.
///
/// Parameters:
/// - [ctx] (required): The [BuildContext] to be used for routing and other context-based actions.
/// - [leadingCallBack] (optional): A callback function to be executed when the leading widget is tapped.
/// - [actionWidget] (optional): A custom widget to be displayed on the action area of the app bar.
/// - [actionCallBack] (optional): A callback function to be executed when the action widget is tapped.
class GlobalAppBar extends AppBar {
  final Widget? leadingWidget;
  final Function? leadingCallBack;
  final BuildContext ctx;
  final Widget? actionWidget;
  final Function? actionCallBack;
  final Color? bgColour;
  GlobalAppBar({
    super.key,
    required this.ctx,
    this.leadingWidget, // Add support for a custom widget.
    this.leadingCallBack,
    this.actionWidget,
    this.actionCallBack,
    this.bgColour
  }) : super(
    backgroundColor: bgColour,
    leading: leadingWidget ??
        InkWell(
          onTap: leadingCallBack as void Function()? ??
                  () {
                GoRouter.of(ctx).pop();
              },
          child: Image.asset(
            'assets/images/back.png',
            scale: 1.3,
          ), // Replace `ic_back.png`.
        ),
    title: Image.asset(
      'assets/images/app_bar_header.png',
      scale: 1.3,
    ),
    centerTitle: true,
    actions: [
      InkWell(
        onTap: actionCallBack as void Function()?,
        child: actionWidget ?? const SizedBox(),
      ),
    ],
    elevation: 0,
  );
}

// class GlobalAppBar extends AppBar {
//   final Widget? leadingWidget;
//   final Function? leadingCallBack;
//   final BuildContext ctx;
//   final Widget? actionWidget;
//   final Function? actionCallBack;
//
//   /// Creates a [GlobalAppBar].
//   ///
//   /// The [ctx] parameter must not be null. If [leadingCallBack] is not provided,
//   /// a default back button is displayed which pops the current route using [GoRouter].
//   /// If [actionWidget] is not provided, a placeholder empty [SizedBox] is used.
//
//   GlobalAppBar(
//       {super.key,
//       required this.ctx,
//       this.leadingWidget,
//       this.leadingCallBack,
//       this.actionWidget,
//       this.actionCallBack})
//       : super(
//     leading: leadingWidget ??
//         InkWell(
//           onTap: leadingCallBack ??
//                   () {
//                 GoRouter.of(ctx).pop();
//               },
//           child: Icon(Icons.arrow_back), // Replace `ic_back.png`.
//         ),
//
//
//           title: Image.asset(
//             'assets/images/app_bar_header.png',
//             scale: 1.3,
//           ),
//           centerTitle: true,
//           actions: [
//             InkWell(
//                 onTap: () => actionCallBack,
//                 child: actionWidget ?? const SizedBox()),
//           ],
//           elevation: 0,
//         );
// }
