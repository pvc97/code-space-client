import 'package:code_space_client/blocs/base/base_state.dart';

abstract class BasePageState<T> extends BaseState {
  final List<T> items;
  final int page;
  final bool isLoadingMore;
  final bool isLoadMoreDone;

  const BasePageState({
    required this.items,
    required this.page,
    required this.isLoadingMore,
    required this.isLoadMoreDone,
    required super.stateStatus,
    super.error,
  });

  @override
  List<Object?> get props => [items, page, isLoadingMore, isLoadMoreDone];
}
