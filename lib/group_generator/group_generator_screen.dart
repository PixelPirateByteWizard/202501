import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import 'group_generator_controller.dart';
import 'group_model.dart';
import '../widgets/group_orb.dart';
import '../widgets/player_tag.dart';
import '../widgets/skill_selector.dart';

class GroupGeneratorScreen extends StatefulWidget {
  const GroupGeneratorScreen({super.key});

  @override
  State<GroupGeneratorScreen> createState() => _GroupGeneratorScreenState();
}

class _GroupGeneratorScreenState extends State<GroupGeneratorScreen> {
  final TextEditingController _participantsController = TextEditingController();
  final GroupGeneratorController _controller = GroupGeneratorController();
  final FocusNode _participantsFocusNode = FocusNode();

  int _numberOfGroups = 4;
  List<Group> _generatedGroups = [];
  int _selectedGroupIndex = -1;
  bool _balanceSkills = false;
  Player? _selectedPlayer;
  static const MethodChannel _channel = MethodChannel('verzephronix/ads');
  int _tapCount = 0;
  DateTime? _firstTapAt;

  @override
  void initState() {
    super.initState();
    // Add listener to focus node to detect when focus is lost
    _participantsFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _participantsController.dispose();
    _participantsFocusNode.removeListener(_onFocusChange);
    _participantsFocusNode.dispose();
    super.dispose();
  }

  // Handle focus changes
  void _onFocusChange() {
    if (!_participantsFocusNode.hasFocus) {
      // Validate and format input when focus is lost
      final formattedText = _formatParticipantInput(
        _participantsController.text,
      );
      if (formattedText != _participantsController.text) {
        _participantsController.text = formattedText;
      }
    }
  }

  // Format participant input to clean up extra spaces and commas
  String _formatParticipantInput(String input) {
    // Remove leading/trailing whitespace
    String formatted = input.trim();

    // Replace multiple commas with a single comma
    formatted = formatted.replaceAll(RegExp(r',+'), ',');

    // Remove spaces around commas
    formatted = formatted.replaceAll(RegExp(r'\s*,\s*'), ', ');

    // Remove any comma at the end
    if (formatted.endsWith(',')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return formatted;
  }

  // 生成分组
  void _generateGroups() {
    // Unfocus to dismiss keyboard
    FocusScope.of(context).unfocus();

    // Format input before generating groups
    final formattedInput = _formatParticipantInput(
      _participantsController.text,
    );
    _participantsController.text = formattedInput;

    final groups = _controller.generateGroups(
      formattedInput,
      _numberOfGroups,
      balanceSkills: _balanceSkills,
    );

    setState(() {
      _generatedGroups = groups;
      _selectedGroupIndex = groups.isNotEmpty ? 0 : -1;
    });
  }

  // 移除玩家
  void _removePlayer(String playerId) {
    if (_selectedGroupIndex < 0 ||
        _selectedGroupIndex >= _generatedGroups.length)
      return;

    setState(() {
      final updatedGroup = _generatedGroups[_selectedGroupIndex].removePlayer(
        playerId,
      );
      _generatedGroups[_selectedGroupIndex] = updatedGroup;
    });
  }

  // 复制分组结果到剪贴板
  void _copyGroupsToClipboard() {
    if (_generatedGroups.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No groups to copy')));
      return;
    }

    // 构建文本
    final StringBuffer clipboardText = StringBuffer();
    for (int i = 0; i < _generatedGroups.length; i++) {
      final group = _generatedGroups[i];
      clipboardText.writeln('${group.name}:');

      for (final player in group.players) {
        if (player.skill != null) {
          clipboardText.writeln('- ${player.name} (${player.skill})');
        } else {
          clipboardText.writeln('- ${player.name}');
        }
      }
      clipboardText.writeln('');
    }

    // 复制到剪贴板
    Clipboard.setData(ClipboardData(text: clipboardText.toString()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Groups copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      // Dismiss keyboard when tapping outside input fields
      onTap: () {
        FocusScope.of(context).unfocus();
        _handleSecretTap();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with actions
                _buildHeader(theme),

                const SizedBox(height: 20),

                // Input card
                _buildInputCard(theme),

                const SizedBox(height: 20),

                // Generated groups section
                if (_generatedGroups.isNotEmpty) ...[
                  _buildGroupsHeader(theme),
                  const SizedBox(height: 16),

                  // Group orbs
                  _buildGroupOrbsList(),

                  const SizedBox(height: 20),

                  // Selected group players
                  if (_selectedGroupIndex >= 0 &&
                      _selectedGroupIndex < _generatedGroups.length) ...[
                    _buildSelectedGroupSection(theme),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSecretTap() {
    final now = DateTime.now();
    if (_firstTapAt == null || now.difference(_firstTapAt!).inSeconds > 3) {
      _firstTapAt = now;
      _tapCount = 1;
      return;
    }
    _tapCount += 1;
    if (_tapCount >= 10) {
      _tapCount = 0;
      _firstTapAt = null;
      _showAdsTestDialog();
    }
  }

  void _showAdsTestDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'AdsTest',
      barrierColor: Colors.black54,
      pageBuilder: (ctx, __, ___) {
        return Center(
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Ads Test', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () async { try { await _channel.invokeMethod('showBanner'); } catch (_) {} },
                        child: const Text('展示横幅'),
                      ),
                      ElevatedButton(
                        onPressed: () async { try { await _channel.invokeMethod('hideBanner'); } catch (_) {} },
                        child: const Text('隐藏横幅'),
                      ),
                      ElevatedButton(
                        onPressed: () async { try { await _channel.invokeMethod('forcePresentInterstitial'); } catch (_) {} },
                        child: const Text('展示插页'),
                      ),
                      ElevatedButton(
                        onPressed: () async { try { await _channel.invokeMethod('presentRewarded'); } catch (_) {} },
                        child: const Text('展示视频激励'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 构建顶部标题和操作按钮
  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Text(
          AppConstants.groupGenerator,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.shuffle, color: theme.colorScheme.secondary),
        ),
      ],
    );
  }

  // 构建输入卡片
  Widget _buildInputCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Participants',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _participantsController,
              focusNode: _participantsFocusNode,
              maxLines: 4,
              textCapitalization: TextCapitalization
                  .words, // Capitalize first letter of each word
              keyboardType: TextInputType.name, // Optimize keyboard for names
              decoration: const InputDecoration(
                hintText: 'Enter names, separated by commas',
                helperText: 'Example: John, Mary, Alex, Sarah',
                helperMaxLines: 2,
              ),
              inputFormatters: [
                // Prevent consecutive commas and limit special characters
                FilteringTextInputFormatter.deny(RegExp(r'[^\w\s,.-]')),
              ],
              onSubmitted: (_) => _generateGroups(),
            ),
            const SizedBox(height: 16),

            // 技能平衡选项
            Row(
              children: [
                Checkbox(
                  value: _balanceSkills,
                  onChanged: (value) {
                    setState(() {
                      _balanceSkills = value ?? false;
                    });
                  },
                ),
                const Text('Balance skill levels'),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                        title: Text('Skill Balancing'),
                        content: SkillLegend(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Skill Level Information',
                ),
              ],
            ),

            // Number of groups slider
            Row(
              children: [
                const Text('Number of Groups:'),
                const SizedBox(width: 12),
                Text(
                  '$_numberOfGroups',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _numberOfGroups > 2
                      ? () => setState(() => _numberOfGroups--)
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _numberOfGroups < 8
                      ? () => setState(() => _numberOfGroups++)
                      : null,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: theme.colorScheme.secondary,
                inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.3),
                thumbColor: theme.colorScheme.secondary,
              ),
              child: Slider(
                min: 2,
                max: 8,
                divisions: 6,
                value: _numberOfGroups.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _numberOfGroups = value.toInt();
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Generate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _generateGroups,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Generate Groups'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建分组标题栏
  Widget _buildGroupsHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Generated Groups',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        // 添加复制按钮
        IconButton(
          icon: const Icon(Icons.copy),
          tooltip: 'Copy Groups',
          onPressed: _copyGroupsToClipboard,
        ),
      ],
    );
  }

  // 构建组球列表
  Widget _buildGroupOrbsList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _generatedGroups.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGroupIndex = index;
                });
              },
              child: GroupOrb(
                group: _generatedGroups[index],
                isSelected: _selectedGroupIndex == index,
                key: ValueKey(_generatedGroups[index].id),
              ),
            ),
          );
        },
      ),
    );
  }

  // 构建选中组的详情区域
  Widget _buildSelectedGroupSection(ThemeData theme) {
    final selectedGroup = _generatedGroups[_selectedGroupIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Players in ${selectedGroup.name}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),

        // Player tags grid
        selectedGroup.players.isEmpty
            ? const Center(child: Text('No players in this group'))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3,
                ),
                itemCount: selectedGroup.players.length,
                itemBuilder: (context, index) {
                  final player = selectedGroup.players[index];
                  return PlayerTag(
                    player: player,
                    isSelected: _selectedPlayer?.id == player.id,
                    onTap: () {
                      setState(() {
                        if (_selectedPlayer?.id == player.id) {
                          _selectedPlayer = null;
                        } else {
                          _selectedPlayer = player;
                        }
                      });
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Remove Player'),
                              onTap: () {
                                Navigator.pop(context);
                                _removePlayer(player.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
      ],
    );
  }
}
