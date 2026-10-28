void main() {
  // group('Debouncer Tests', () {
  //   test('Debouncer delays action execution', () async {
  //     int counter = 0;
  //     final debouncer = Debouncer(milliseconds: 100);
  //
  //     debouncer.run(() {
  //       counter++;
  //     });
  //
  //     // Initially counter should be 0 before timer completes
  //     expect(counter, 0);
  //
  //     // Wait for debouncer duration to elapse
  //     await Future.delayed(const Duration(milliseconds: 150));
  //     expect(counter, 1);
  //   });
  // });
  //
  // group('BooleanResponseModel Tests', () {
  //   test('BooleanResponseModel parses json correctly with PascalCase keys', () {
  //     final json = {
  //       'StatusCode': 200,
  //       'HasError': false,
  //       'Message': 'Success',
  //       'data': {'id': 1},
  //     };
  //
  //     final model = BooleanResponseModel.fromJson(json);
  //
  //     expect(model.statusCode, 200);
  //     expect(model.hasError, false);
  //     expect(model.message, 'Success');
  //     expect(model.data['id'], 1);
  //   });
  //
  //   test('BooleanResponseModel parses json correctly with snake_case keys', () {
  //     final json = {
  //       'status_code': 400,
  //       'has_error': true,
  //       'message': 'Error occurred',
  //       'data': null,
  //     };
  //
  //     final model = BooleanResponseModel.fromJson(json);
  //
  //     expect(model.statusCode, 400);
  //     expect(model.hasError, true);
  //     expect(model.message, 'Error occurred');
  //     expect(model.data, null);
  //   });
  // });
}
