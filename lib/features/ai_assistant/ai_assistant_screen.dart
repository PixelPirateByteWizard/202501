import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/models/ai_report_model.dart';
import '../../shared/widgets/themed_card.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<String> _presetQuestions = ApiService.getPresetQuestions();
  bool _isLoading = false;
  bool _showPresetQuestions = true;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _messages.isEmpty && _showPresetQuestions
                ? _buildPresetQuestions()
                : _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: const Text(
        'VerseAI 洞察引擎',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFE6EDF3),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16, left: 50),
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFF4A90E2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
          child: Text(
            message.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24, right: 20),
          child: message.isLoading
              ? _buildLoadingMessage()
              : _buildAIReportCard(message.report!),
        ),
      );
    }
  }

  Widget _buildLoadingMessage() {
    return ThemedCard(
      backgroundColor: const Color(0xFF161B22),
      border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.5)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'VerseAI 正在分析...',
            style: TextStyle(
              color: Color(0xFF8B949E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIReportCard(AIReport report) {
    return ThemedCard(
      backgroundColor: const Color(0xFF161B22),
      border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Project Nebula (NEBU)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE6EDF3),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '360° 投研速报',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B949E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFE6EDF3),
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: 'AI一句话总结: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
                TextSpan(text: report.summary),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                '综合风险评级: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6EDF3),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getRiskColor(report.riskLevel).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getRiskText(report.riskLevel),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getRiskColor(report.riskLevel),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D3447),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Color(0xFFE6EDF3)),
                decoration: const InputDecoration(
                  hintText: '向 VerseAI 提问...',
                  hintStyle: TextStyle(color: Color(0xFF8B949E)),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isLoading
                    ? const Color(0xFF8B949E)
                    : const Color(0xFF4A90E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage([String? presetQuestion]) async {
    final text = presetQuestion ?? _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(content: text, isUser: true));
      _messages.add(ChatMessage(content: '', isUser: false, isLoading: true));
      _isLoading = true;
      _showPresetQuestions = false; // 隐藏预设问题
    });

    if (presetQuestion == null) {
      _messageController.clear();
    }

    try {
      final report = await ApiService.getAIReport(text);
      // 检查组件是否仍然挂载，防止页面切换时的闪退
      if (mounted) {
        setState(() {
          _messages.last =
              ChatMessage(content: '', isUser: false, report: report);
          _isLoading = false;
        });
      }
    } catch (e) {
      // 检查组件是否仍然挂载
      if (mounted) {
        setState(() {
          _messages.removeLast();
          _isLoading = false;
        });
      }
    }
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return const Color(0xFF4ADE80);
      case RiskLevel.medium:
        return const Color(0xFFFBBF24);
      case RiskLevel.high:
        return const Color(0xFFF87171);
    }
  }

  String _getRiskText(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return '低风险';
      case RiskLevel.medium:
        return '中风险';
      case RiskLevel.high:
        return '中高风险';
    }
  }

  Widget _buildPresetQuestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👋 欢迎使用 VerseAI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '我是您的专属Web3.0和加密货币分析师，可以为您解答相关问题。请注意，我不会提供具体的投资建议。',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8B949E),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '💡 热门问题',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
          ),
          const SizedBox(height: 16),
          ...(_presetQuestions
              .take(6)
              .map((question) => _buildPresetQuestionItem(question))),
          const SizedBox(height: 16),
          ThemedCard(
            backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
            border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Color(0xFF4A90E2), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '免责声明',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• 本AI助手仅提供教育和信息目的的内容\n• 不构成投资建议，请自行研究和判断\n• 加密货币投资存在高风险，可能损失全部本金\n• 请根据自身风险承受能力谨慎投资',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B949E),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetQuestionItem(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _sendMessage(question),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3447).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.help_outline,
                color: Color(0xFF4A90E2),
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFFE6EDF3),
                    height: 1.3,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF8B949E),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final bool isLoading;
  final AIReport? report;

  ChatMessage({
    required this.content,
    required this.isUser,
    this.isLoading = false,
    this.report,
  });
}
