import 'package:equatable/equatable.dart';
import '../../../data/models/user/user.dart';
import '../../../data/models/user/user_profile.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final UserProfile? profile;
  final String? error;
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
    String? error,
    String? successMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, profile, error, successMessage];
}
