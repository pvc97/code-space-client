import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

class BlocTransformer {
  BlocTransformer._();

  // Debounce the search event
  // https://github.com/felangel/bloc/blob/master/examples/github_search/common_github_search/lib/src/github_search_bloc/github_search_bloc.dart
  static EventTransformer<Event> debounce<Event>(Duration duration) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }

  static EventTransformer<Event> throttle<Event>(Duration duration) {
    return (events, mapper) => events.throttle(duration).switchMap(mapper);
  }
}
