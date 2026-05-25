/// 🔥 PREMIUM ERROR HANDLING SYSTEM
/// Errors should feel calm, helpful, and recoverable

abstract class PondException implements Exception {
  final String message;
  final String? technicalDetails;

  PondException({required this.message, this.technicalDetails});

  @override
  String toString() => message;
}

// ❌ ADD POND ERRORS
class AddPondNetworkException extends PondException {
  AddPondNetworkException({String? details})
    : super(
        message: 'Couldn\'t add pond. Please check your connection.',
        technicalDetails: details,
      );
}

class AddPondValidationException extends PondException {
  AddPondValidationException({required String field})
    : super(message: 'Please enter a valid $field.');
}

class AddPondDuplicateException extends PondException {
  AddPondDuplicateException()
    : super(message: 'A pond with this name already exists.');
}

class AddPondGenericException extends PondException {
  AddPondGenericException({String? details})
    : super(
        message: 'Couldn\'t add pond. Please try again.',
        technicalDetails: details,
      );
}

// ❌ DELETE POND ERRORS
class DeletePondNetworkException extends PondException {
  DeletePondNetworkException({String? details})
    : super(message: 'Failed to delete pond.', technicalDetails: details);
}

class DeletePondGenericException extends PondException {
  DeletePondGenericException({String? details})
    : super(
        message: 'Failed to delete pond. Please try again.',
        technicalDetails: details,
      );
}

// ❌ FETCH PONDS ERRORS
class FetchPondsNetworkException extends PondException {
  FetchPondsNetworkException({String? details})
    : super(
        message: 'Couldn\'t load ponds. Please check your connection.',
        technicalDetails: details,
      );
}

class FetchPondsGenericException extends PondException {
  FetchPondsGenericException({String? details})
    : super(
        message: 'Something went wrong. Please try again.',
        technicalDetails: details,
      );
}

// 🌐 NETWORK ERRORS
class NetworkException extends PondException {
  NetworkException() : super(message: 'No internet connection');
}
