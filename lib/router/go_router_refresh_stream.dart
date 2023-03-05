import 'dart:async';

import 'package:code_space_client/blocs/auth/auth_cubit.dart';
import 'package:flutter/foundation.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream({
    required Stream<AuthState> stream,
    bool Function(AuthState, AuthState)? equals,
  }) {
    notifyListeners();
    _subscription = stream
        .asBroadcastStream()
        .distinct(equals)
        .listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
