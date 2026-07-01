import 'package:equatable/equatable.dart';
import '../../../core/widgets/message_bloc_listener.dart';
import '../../../data/models/user/user.dart';
import '../../../data/models/user/user_profile.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

const _unset = Object();

class AuthState extends Equatable implements MessageState {
  final AuthStatus status;
  final User? user;
  final UserProfile? profile;
  @override
  final String? error;
  @override
  final String? successMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.profile,
    this.error,
    this.successMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    UserProfile? profile,
    Object? error = _unset,
    Object? successMessage = _unset,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      error: identical(error, _unset) ? this.error : error as String?,
      successMessage: identical(successMessage, _unset)
          ? this.successMessage
          : successMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, user, profile, error, successMessage];
}
