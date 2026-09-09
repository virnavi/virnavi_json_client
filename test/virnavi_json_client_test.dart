import 'package:flutter_test/flutter_test.dart';
import 'package:virnavi_json_client/virnavi_json_client.dart';

class _JsonReq extends BaseJson {
  final String value;
  _JsonReq(this.value);

  @override
  Map<String, dynamic> toJson() => {'value': value};
}

void main() {
  group('ApiResponse', () {
    test('isSuccess for 200', () {
      final r = ApiResponse<String, String>(code: 200, response: 'ok');
      expect(r.isSuccess, isTrue);
      expect(r.isError, isFalse);
      expect(r.isException, isFalse);
    });

    test('isSuccess for 299', () {
      expect(ApiResponse<String, String>(code: 299).isSuccess, isTrue);
    });

    test('isError for 400', () {
      final r = ApiResponse<String, String>(code: 400, errorResponse: 'err');
      expect(r.isError, isTrue);
      expect(r.isSuccess, isFalse);
      expect(r.isException, isFalse);
    });

    test('isError for 500', () {
      expect(ApiResponse<String, String>(code: 500).isError, isTrue);
    });

    test('isException for -1', () {
      final r = ApiResponse<String, String>(
        code: -1,
        exception: Exception('network error'),
      );
      expect(r.isException, isTrue);
      expect(r.isSuccess, isFalse);
      expect(r.isError, isFalse);
    });

    test('300 is neither success nor exception', () {
      final r = ApiResponse<String, String>(code: 300);
      expect(r.isSuccess, isFalse);
      expect(r.isException, isFalse);
      expect(r.isError, isTrue);
    });
  });

  group('ApiMethod', () {
    test('all expected values are present', () {
      final methods = ApiMethod.values.map((e) => e.name).toSet();
      expect(methods, containsAll(['get', 'post', 'put', 'patch', 'delete', 'formData']));
    });
  });

  group('BaseJson', () {
    test('toJson returns expected map', () {
      final req = _JsonReq('hello');
      expect(req.toJson(), equals({'value': 'hello'}));
    });
  });

  group('BaseFormData', () {
    test('toJson returns empty map by default', () {
      final form = _Upload();
      expect(form.toJson(), equals(<String, dynamic>{}));
    });

    test('is a BaseJson', () {
      expect(_Upload(), isA<BaseJson>());
    });
  });

  group('BaseHttpJsonObjectClientOptions', () {
    test('defaults are sensible', () {
      final opts = BaseHttpJsonObjectClientOptions();
      expect(opts.connectTimeout, equals(const Duration(seconds: 30)));
      expect(opts.receiveTimeout, equals(const Duration(seconds: 30)));
      expect(opts.sendTimeout, equals(const Duration(seconds: 30)));
    });

    test('custom values are stored', () {
      final opts = BaseHttpJsonObjectClientOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),
      );
      expect(opts.connectTimeout, equals(const Duration(seconds: 10)));
      expect(opts.receiveTimeout, equals(const Duration(seconds: 60)));
    });
  });

  group('convertRawResponse', () {
    final client = BaseHttpJsonObjectClient(
      baseUrl: '',
      options: BaseHttpJsonObjectClientOptions(),
    );

    Response<String> raw(String? body, {int status = 200}) => Response<String>(
      requestOptions: RequestOptions(path: '/'),
      statusCode: status,
      data: body,
    );

    test('decodes a JSON object body', () {
      expect(client.convertRawResponse(raw('{"a":1}')).data, {'a': 1});
    });

    test('empty body decodes to an empty map (no crash on 204)', () {
      expect(client.convertRawResponse(raw('')).data, isEmpty);
      expect(client.convertRawResponse(raw(null)).data, isEmpty);
      expect(client.convertRawResponse(raw('   ')).data, isEmpty);
    });

    test('non-object JSON throws a catchable FormatException, not a TypeError', () {
      expect(() => client.convertRawResponse(raw('[1,2,3]')),
          throwsA(isA<FormatException>()));
      expect(() => client.convertRawResponse(raw('42')),
          throwsA(isA<FormatException>()));
    });

    test('malformed JSON throws a catchable FormatException', () {
      expect(() => client.convertRawResponse(raw('{not json')),
          throwsA(isA<FormatException>()));
    });

    test('onTransformRawData takes precedence over default decoding', () {
      final transforming = BaseHttpJsonObjectClient(
        baseUrl: '',
        options: BaseHttpJsonObjectClientOptions(),
        onTransformRawData: (data, response) => {'wrapped': data},
      );
      expect(transforming.convertRawResponse(raw('anything')).data,
          {'wrapped': 'anything'});
    });
  });
}

class _Upload extends BaseFormData {
  @override
  Future<FormData> toFormData() async => FormData();
}
