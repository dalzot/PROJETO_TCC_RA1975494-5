class CustomResponse {
  int statuscode;
  String message;
  CustomResponse({required this.statuscode, required this.message});

  @override
  String toString() {
    return "CustomResponse{statuscode:$statuscode, message:$message}";
  }
}
