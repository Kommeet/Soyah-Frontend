/// An exception class for errors encountered while interacting with the Teide api.
///
/// This exception captures the HTTP status code (`code`) and a descriptive error message (`message`).
/// Optionally, it can also hold an inner exception (`innerException`) for nested error scenarios.
class ApiException implements Exception {
  /// The HTTP status code associated with the error.
  final int code;

  /// A human-readable message describing the error.
  final String? message;

  /// An inner exception that may have caused this exception (optional).
  final Exception? innerException;

  ApiException({
    required this.code,
    this.message,
    this.innerException,
  });

  /// Returns a human-readable message based on the HTTP status code.
  ///
  /// This method provides a default message for common status codes.
  /// You can customize this behavior by overriding it in subclasses.
  String getStatusCodeMessage() {
    switch (code) {
      case 400:
        return 'Bad Request: The request was invalid.';
      case 401:
        return 'Unauthorized: You are not authorized to access this resource.';
      case 403:
        return 'Forbidden: You are not allowed to access this resource.';
      case 404:
        return 'Not Found: The resource you requested could not be found.';
      case 405:
        return 'Method Not Allowed: The HTTP method used is not supported.';
      case 409:
        return 'Conflict: The request could not be completed due to a conflict.';
      case 422:
        return 'Unprocessable Entity: The request was well-formed but was unable to be processed.';
      case 500:
        return 'Internal Server Error: An unexpected error occurred on the server.';
      case 502:
        return 'Bad Gateway: The server received an invalid response from an upstream server.';
      case 503:
        return 'Service Unavailable: The server is currently unavailable.';
      default:
        return 'Unknown Error: An error occurred with status code $code.';
    }
  }

  @override
  String toString() {
    final statusCodeMessage = getStatusCodeMessage();
    if (innerException == null) {
      return 'ApiException: code: $code, message: $statusCodeMessage';
    }
    return 'ApiException: code: $code, message: $statusCodeMessage (Inner exception: $message)';
  }
}
