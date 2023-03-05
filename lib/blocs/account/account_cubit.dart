import 'package:code_space_client/blocs/base/base_state.dart';
import 'package:code_space_client/constants/network_constants.dart';
import 'package:code_space_client/models/app_exception.dart';
import 'package:code_space_client/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountState.initial());
}
