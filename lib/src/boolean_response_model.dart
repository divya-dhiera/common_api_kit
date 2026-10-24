class BooleanResponseModel {
  int? statusCode;
  bool? hasError;
  String? message;
  dynamic data;

  BooleanResponseModel({
    this.statusCode,
    this.hasError,
    this.message,
    this.data,
  });

  factory BooleanResponseModel.fromJson(Map<String, dynamic> json) {
    return BooleanResponseModel(
      statusCode: json['StatusCode'] ?? json['status_code'],
      hasError: json['HasError'] ?? json['has_error'],
      message: json['Message'] ?? json['message'],
      data: json['data'],
    );
  }
}
