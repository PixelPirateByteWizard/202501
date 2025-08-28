import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/radio_model.dart';
import '../utils/ai_service.dart';

class RadioChatPage extends StatefulWidget {
  final RadioStation station;

  const RadioChatPage({super.key, required this.station});

  @override
  State<RadioChatPage> createState() => _RadioChatPageState();
}

class _RadioChatPageState extends State<RadioChatPage> {
  // 存储被屏蔽的消息ID
  final Set<String> _blockedMessageIds = {};
  final AiService _aiService = AiService();

  // 控制器
  late TextEditingController _messageController;
  final ScrollController _scrollController = ScrollController();

  // 聊天消息
  List<ChatMessage> _messages = [];

  // 是否正在加载回复
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();

    // 发送欢迎消息
    _messages = [
      ChatMessage(
        text: _getWelcomeMessage(),
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];

    // 延迟一下，确保UI已经构建完成后再滚动到底部
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 获取欢迎消息
  String _getWelcomeMessage() {
    return '欢迎来到"${widget.station.name}"的聊天室！我是你的音乐电台主持人，可以和你聊关于${widget.station.category}的话题。${widget.station.description}。有什么想聊的吗？';
  }

  // 发送消息
  void _sendMessage() async {
    // 检查输入内容是否为空
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    // 清空输入框并收起键盘
    _messageController.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _messages.add(
        ChatMessage(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    // 滚动到底部
    _scrollToBottom();

    // 获取AI回复
    try {
      // 构建一个特殊的提示，让AI扮演电台主持人
      final prompt =
          "用户正在与电台'${widget.station.name}'聊天，电台类型是'${widget.station.category}'，电台描述：'${widget.station.description}'。请你扮演这个电台的主持人，回答用户的问题：$userMessage";

      final response = await _aiService.getChatResponse(prompt, 'radio');

      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: response,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });

        // 滚动到底部
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: '抱歉，我遇到了一些问题。请稍后再试。',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });

        // 滚动到底部
        _scrollToBottom();
      }
    }
  }

  // 滚动到底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 定义主题颜色
    final Color primaryColor = const Color(0xFF6B2C9E);
    final Color secondaryColor = const Color(0xFFFF2A6D);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Hero(
              tag: 'radio_${widget.station.id}',
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      secondaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.station.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.radio,
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.station.name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.station.category,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '聊天室',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // 清空聊天记录按钮
          IconButton(
            icon: Icon(
              Icons.delete_sweep,
              color: _messages.length > 1 ? Colors.black87 : Colors.black26,
            ),
            onPressed: _messages.length > 1 ? _clearChatHistory : null,
            tooltip: '清空聊天记录',
          ),
        ],
      ),
      body: GestureDetector(
        // 点击非输入框区域收起键盘
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F1A2C),
                  Color(0xFF1a0625),
                ],
              ),
            ),
            child: Column(
              children: [
                // 聊天消息列表
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    itemCount: _messages.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // 添加日期分隔线
                      if (index == 0 || _shouldShowDateSeparator(index)) {
                        return Column(
                          children: [
                            _buildDateSeparator(_messages[index].timestamp),
                            const SizedBox(height: 16),
                            _buildMessageBubble(_messages[index]),
                          ],
                        );
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
                ),
                // 加载指示器
                if (_isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A0B47).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '思考中...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                // 输入框区域
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2A0B47),
                        Color(0xFF1a0625),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B2C9E).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, -3),
                        spreadRadius: 1,
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFFF2A6D).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 输入框
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A0B47).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                                spreadRadius: 1,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF4A1A6B).withOpacity(0.2),
                                const Color(0xFF2A0B47).withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: '和电台主持人聊聊吧...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              isDense: true,
                              // 添加一个小图标作为提示
                              prefixIcon: Container(
                                margin:
                                    const EdgeInsets.only(left: 12, right: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF6B2C9E).withOpacity(0.7),
                                      const Color(0xFFFF2A6D).withOpacity(0.5),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              // 添加一个细微的底部边框
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xFFFF2A6D).withOpacity(0.3),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xFFFF2A6D).withOpacity(0.5),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            maxLines: 3, // 限制最多3行
                            minLines: 1,
                            maxLength: 300, // 设置最大字符数为300，更合理的限制
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            buildCounter: (context,
                                {required currentLength,
                                required isFocused,
                                maxLength}) {
                              // 不显示字符计数
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            onSubmitted: (_) => _sendMessage(),
                            // 添加输入变化监听，用于更新UI状态
                            onChanged: (text) {
                              // 强制刷新发送按钮状态
                              setState(() {});
                            },
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.3,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 发送按钮
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // 检查输入框是否有内容
                            if (_messageController.text.trim().isNotEmpty) {
                              _sendMessage();
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _messageController.text.trim().isNotEmpty
                                      ? const Color(0xFFFF2A6D)
                                      : const Color(0xFF4A1A6B)
                                          .withOpacity(0.5),
                                  _messageController.text.trim().isNotEmpty
                                      ? const Color(0xFF6B2C9E)
                                      : const Color(0xFF2A0B47)
                                          .withOpacity(0.7),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _messageController.text
                                          .trim()
                                          .isNotEmpty
                                      ? const Color(0xFFFF2A6D).withOpacity(0.4)
                                      : const Color(0xFF6B2C9E)
                                          .withOpacity(0.3),
                                  blurRadius:
                                      _messageController.text.trim().isNotEmpty
                                          ? 12
                                          : 6,
                                  spreadRadius:
                                      _messageController.text.trim().isNotEmpty
                                          ? 2
                                          : 0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.send_rounded,
                              color: _messageController.text.trim().isNotEmpty
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.7),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 判断是否需要显示日期分隔线
  bool _shouldShowDateSeparator(int index) {
    if (index == 0) return true;

    final currentDate = _messages[index].timestamp;
    final previousDate = _messages[index - 1].timestamp;

    return !_isSameDay(currentDate, previousDate);
  }

  // 判断两个日期是否是同一天
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // 构建日期分隔线
  Widget _buildDateSeparator(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  // 举报消息
  void _reportMessage(ChatMessage message) {
    // 显示举报弹窗
    showDialog(
      context: context,
      builder: (context) => _ReportDialog(
        message: message,
        onReportSubmitted: (reason, details) {
          // 显示举报成功提示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已举报该消息: $reason'),
              backgroundColor: Colors.orange[700],
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  // 屏蔽消息
  void _blockMessage(ChatMessage message) {
    // 显示屏蔽弹窗
    showDialog(
      context: context,
      builder: (context) => _BlockDialog(
        message: message,
        onBlockSubmitted: (reason, details) {
          setState(() {
            _blockedMessageIds.add(message.id);
          });

          // 显示屏蔽成功提示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已屏蔽该消息: $reason'),
              backgroundColor: Colors.red[700],
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  // 清空聊天记录
  void _clearChatHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空聊天记录'),
        content: const Text('确定要清空所有聊天记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // 保留欢迎消息
                _messages = [
                  ChatMessage(
                    text: _getWelcomeMessage(),
                    isUser: false,
                    timestamp: DateTime.now(),
                  ),
                ];
                _blockedMessageIds.clear();
              });
              Navigator.of(context).pop();

              // 显示清空成功提示
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('聊天记录已清空'),
                  backgroundColor: Colors.green[700],
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 构建消息气泡
  Widget _buildMessageBubble(ChatMessage message) {
    // 如果消息被屏蔽，则不显示
    if (_blockedMessageIds.contains(message.id)) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '该消息已被屏蔽',
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontStyle: FontStyle.italic),
        ),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuint,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 助手头像
          Visibility(
            visible: !message.isUser,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAvatar(isUser: false),
                const SizedBox(width: 8),
              ],
            ),
          ),
          // 消息内容
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                // 只有非用户消息才能举报和屏蔽
                if (!message.isUser) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A0B47),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.report_outlined,
                                color: Colors.orange),
                            title: const Text('举报此消息',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _reportMessage(message);
                            },
                          ),
                          const Divider(height: 1, color: Colors.white24),
                          ListTile(
                            leading: const Icon(Icons.block, color: Colors.red),
                            title: const Text('屏蔽此消息',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _blockMessage(message);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width < 360
                      ? MediaQuery.of(context).size.width * 0.65
                      : MediaQuery.of(context).size.width * 0.7,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: message.isUser
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(message.isUser ? 20 : 4),
                    topRight: Radius.circular(message.isUser ? 4 : 20),
                    bottomLeft: Radius.circular(message.isUser ? 20 : 16),
                    bottomRight: Radius.circular(message.isUser ? 16 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: message.isUser
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: message.isUser
                      ? null
                      : Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // 消息内容
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    // 时间戳
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.isUser)
                          Icon(
                            Icons.done_all,
                            size: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        if (message.isUser) const SizedBox(width: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            color: message.isUser
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 用户头像
          Visibility(
            visible: message.isUser,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                _buildAvatar(isUser: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建头像
  Widget _buildAvatar({required bool isUser}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUser
            ? LinearGradient(
                colors: [
                  Colors.grey[400]!,
                  Colors.grey[500]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withBlue(
                        (Theme.of(context).primaryColor.blue + 40)
                            .clamp(0, 255),
                      ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: isUser
                ? Colors.grey[300]!
                : Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isUser ? Icons.person : Icons.radio,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  // 格式化时间
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return '今天';
    } else if (messageDate == yesterday) {
      return '昨天';
    } else {
      // 显示完整日期
      return '${date.year}年${date.month}月${date.day}日';
    }
  }
}

// 举报对话框
class _ReportDialog extends StatefulWidget {
  final ChatMessage message;
  final Function(String reason, String details) onReportSubmitted;

  const _ReportDialog({
    required this.message,
    required this.onReportSubmitted,
  });

  @override
  __ReportDialogState createState() => __ReportDialogState();
}

class __ReportDialogState extends State<_ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedReason = '垃圾广告';
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _reportReasons = ['垃圾广告', '色情低俗', '违法信息', '恶意攻击', '其他'];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击对话框外部时收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Dialog(
        backgroundColor: const Color(0xFF2A0B47),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFFFF2A6D).withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                const Text(
                  '举报消息',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // 消息预览
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.message.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 16),

                // 原因选择
                const Text(
                  '选择举报原因:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedReason,
                  dropdownColor: const Color(0xFF3A1B57),
                  iconEnabledColor: Colors.white,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF3A1B57),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: _reportReasons
                      .map((reason) => DropdownMenuItem(
                            value: reason,
                            child: Text(
                              reason,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value!;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // 详细说明
                const Text(
                  '详细说明 (可选):',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _detailsController,
                  maxLines: 3,
                  maxLength: 200,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF3A1B57),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 24),

                // 按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                          widget.onReportSubmitted(
                            _selectedReason,
                            _detailsController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2A6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('提交举报'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 屏蔽对话框
class _BlockDialog extends StatefulWidget {
  final ChatMessage message;
  final Function(String reason, String details) onBlockSubmitted;

  const _BlockDialog({
    required this.message,
    required this.onBlockSubmitted,
  });

  @override
  __BlockDialogState createState() => __BlockDialogState();
}

class __BlockDialogState extends State<_BlockDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedReason = '不想看到此内容';
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _blockReasons = ['不想看到此内容', '话题不感兴趣', '其他'];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击对话框外部时收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Dialog(
        backgroundColor: const Color(0xFF2A0B47),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: const Color(0xFFFF2A6D).withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                const Text(
                  '屏蔽消息',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // 消息预览
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.message.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 16),

                // 说明文字
                const Text(
                  '屏蔽后，您将不再看到此消息。',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),

                // 原因选择
                const Text(
                  '选择屏蔽原因:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedReason,
                  dropdownColor: const Color(0xFF3A1B57),
                  iconEnabledColor: Colors.white,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF3A1B57),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: _blockReasons
                      .map((reason) => DropdownMenuItem(
                            value: reason,
                            child: Text(
                              reason,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value!;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // 详细说明
                const Text(
                  '详细说明 (可选):',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _detailsController,
                  maxLines: 3,
                  maxLength: 200,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF3A1B57),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 24),

                // 按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                          widget.onBlockSubmitted(
                            _selectedReason,
                            _detailsController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2A6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('确认屏蔽'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 聊天消息模型
class ChatMessage {
  final String id; // 添加ID用于标识消息
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString() +
            (text.length > 5 ? text.substring(0, 5) : text);
}
