abstract class PrivacyState {}

class PrivacyInitial extends PrivacyState {}

class PrivacyLoaded extends PrivacyState {
  final String privacyText;

  PrivacyLoaded(this.privacyText);
}

class PrivacyError extends PrivacyState {
  final String message;

  PrivacyError(this.message);
}