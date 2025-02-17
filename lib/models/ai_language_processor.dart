import 'dart:convert';
import 'dart:developer' as devLog;
import 'package:http/http.dart' as httpUtil;
import 'dart:async';

class AILanguageProcessor {
  static final AILanguageProcessor _singleton = AILanguageProcessor._private();

  String _secretToken = 'sk-YbCIlQSumgpzouQD9vGsRhDsGqvsOhwKuPNybaEFNrfwDzJV';

  String _urlSegmentHttp = 'h';
  String _urlSegmentH = 'h';
  String _urlSegmentT = 't';
  String _urlSegmentP = 'p';
  String _urlSegmentS = 's';
  String _urlSegmentColon = ':';
  String _urlSegmentSlash = '/';
  String _urlSegmentDot = '.';
  String _urlSegmentA = 'a';
  String _urlSegmentI = 'i';
  String _urlSegmentK = 'k';
  String _urlSegmentJ = 'j';
  String _urlSegmentO = 'o';
  String _urlSegmentR = 'r';
  String _urlSegmentG = 'g';
  String _urlSegmentN = 'n';
  String _urlSegmentV = 'v';
  String _urlSegmentC = 'c';
  String _urlSegmentM = 'm';
  String _urlSegmentL = 'l';
  String _urlSegmentE = 'e';
  String _urlSegmentT1 = 't';

  late String _endpointUrl;
  static const int _maxRetries = 3;
  static const Duration _backoffInterval = Duration(seconds: 2);
  late final httpUtil.Client _networkClient;
  bool _isTerminated = false;

  factory AILanguageProcessor() {
    return _singleton;
  }

  AILanguageProcessor._private() {
    _networkClient = httpUtil.Client();
    _endpointUrl = _urlSegmentHttp +
        _urlSegmentT +
        _urlSegmentT +
        _urlSegmentP +
        _urlSegmentS +
        _urlSegmentColon +
        _urlSegmentSlash +
        _urlSegmentSlash +
        _urlSegmentA +
        _urlSegmentP +
        _urlSegmentI +
        _urlSegmentDot +
        _urlSegmentK +
        _urlSegmentK +
        _urlSegmentS +
        _urlSegmentJ +
        _urlSegmentDot +
        _urlSegmentO +
        _urlSegmentR +
        _urlSegmentG +
        _urlSegmentSlash +
        _urlSegmentV +
        '1' +
        _urlSegmentSlash +
        _urlSegmentC +
        _urlSegmentH +
        _urlSegmentA +
        _urlSegmentT +
        _urlSegmentSlash +
        _urlSegmentC +
        _urlSegmentO +
        _urlSegmentM +
        _urlSegmentP +
        _urlSegmentL +
        _urlSegmentE +
        _urlSegmentT +
        _urlSegmentI +
        _urlSegmentO +
        _urlSegmentN +
        _urlSegmentS;
  }

  Future<String> generateResponse(String userInput) async {
    if (userInput.isEmpty) {
      return '请输入有效问题';
    }

    devLog.log('用户输入: $userInput');

    final requestBody = _createRequestBody(userInput);
    final requestHeaders = _prepareHeaders();

    return _performNetworkCall(requestBody, requestHeaders);
  }

  Future<String> _performNetworkCall(
      String requestBody, Map<String, String> requestHeaders) async {
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        devLog.log('开始发送请求，尝试次数: ${attempt + 1}');

        final response = await _networkClient
            .post(
              Uri.parse(_endpointUrl),
              headers: requestHeaders,
              body: requestBody,
            )
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException('请求超时'),
            );

        devLog.log(
            '收到响应：状态码=${response.statusCode}, 响应体长度=${response.body.length}');
        devLog.log('响应体内容: ${response.body}');

        if (response.statusCode == 200) {
          final result = _parseResponseData(response);
          devLog.log('解析后的响应: $result');
          return result;
        } else if ([429, 503, 524].contains(response.statusCode)) {
          final waitTime = _backoffInterval * (attempt + 1) * 2;
          devLog.log(
              '服务器错误 ${response.statusCode}。将在 ${waitTime.inSeconds} 秒后重试。');
          await Future.delayed(waitTime);
        } else {
          throw AIProcessorException(
              'HTTP错误 ${response.statusCode}: ${response.body}');
        }
      } on TimeoutException catch (e) {
        devLog.log('请求超时: $e');
        if (attempt == _maxRetries - 1) {
          throw AIProcessorException('请求多次超时，请稍后重试。');
        }
        await Future.delayed(_backoffInterval * (attempt + 1));
      } catch (e) {
        devLog.log('发生错误: $e');
        if (attempt == _maxRetries - 1) {
          throw AIProcessorException('多次请求失败，请检查网络连接后重试。');
        }
        await Future.delayed(_backoffInterval * (attempt + 1));
      }
    }
    throw AIProcessorException('请求失败，请检查网络连接。');
  }

  Map<String, String> _prepareHeaders() {
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $_secretToken',
    };
  }

  String _createRequestBody(String userInput) {
    return jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': _getAIInstructions()},
        {'role': 'user', 'content': userInput},
      ],
    });
  }

  String _getAIInstructions() {
    return "You are a friendly AI assistant. Please answer questions in the user's language. Avoid discussing health-related topics; for such questions, provide links to reliable information sources.";
  }

  String _parseResponseData(httpUtil.Response networkResponse) {
    try {
      final decodedBody = utf8.decode(networkResponse.bodyBytes);
      devLog.log('解码后的响应: $decodedBody');

      final jsonData = jsonDecode(decodedBody);
      devLog.log('JSON解析后的响应: $jsonData');

      final content = jsonData['choices']?[0]?['message']?['content'];
      if (content == null) {
        devLog.log('警告：无法从响应中提取content字段');
        throw AIProcessorException('服务器响应格式异常');
      }
      return content;
    } catch (e) {
      devLog.log('解析响应时出错: $e');
      throw AIProcessorException('解析服务器响应时出错: $e');
    }
  }

  void terminate() {
    _isTerminated = true;
  }
}

class AIProcessorException implements Exception {
  final String details;
  AIProcessorException(this.details);
  @override
  String toString() => details;
}
