import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'group_model.dart';

class GroupGeneratorController {
  // 存储键
  static const String _savedGroupsKey = 'saved_groups';
  static const String _savedPlayersKey = 'saved_players';
  static const String _savedHistoryKey = 'group_history';

  // 从玩家名称列表生成小组
  List<Group> generateGroups(
    //sdfsdfsdf
    String playerNamesText,
    int numberOfGroups, {
    bool balanceSkills = false,
  }) {
    // 解析玩家名称
    final playerNames = _parsePlayerNames(playerNamesText);

    // 创建玩家对象
    final players =
        playerNames.map((name) => Player.fromName(name.trim())).toList();

    // 随机打乱玩家顺序
    players.shuffle(Random());

    // 创建空组
    final groups = List.generate(
      numberOfGroups,
      (index) => Group.create('Group ${index + 1}'),
    );

    // 将玩家均匀分配到小组中
    final populatedGroups = _distributePlayersToGroups(
      players,
      groups,
      balanceSkills,
    );

    // 保存到历史记录
    _saveToHistory(populatedGroups);

    return populatedGroups;
  }

  // 解析逗号分隔的玩家名称文本
  List<String> _parsePlayerNames(String text) {
    if (text.isEmpty) return [];

    // 按逗号分割并过滤空名称
    return text
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
  }

  // 将玩家均匀分配到小组中
  List<Group> _distributePlayersToGroups(
    List<Player> players,
    List<Group> groups,
    bool balanceSkills,
  ) {
    if (players.isEmpty || groups.isEmpty) return groups;

    final int totalPlayers = players.length;
    final int numberOfGroups = groups.length;

    // 计算每组的基本玩家数和余数
    final int basePlayersPerGroup = totalPlayers ~/ numberOfGroups;
    final int remainder = totalPlayers % numberOfGroups;

    // 创建一个新的小组列表来填充
    final List<Group> populatedGroups = [];

    // 如果需要平衡技能，可以在这里实现更复杂的分配算法
    // 目前使用简单的均匀分配

    int playerIndex = 0;

    // 将玩家分配到小组
    for (int i = 0; i < numberOfGroups; i++) {
      // 计算这个小组应该有多少玩家
      final int playersInThisGroup =
          i < remainder ? basePlayersPerGroup + 1 : basePlayersPerGroup;

      // 创建一个具有适当名称的小组
      Group group = Group.create('Group ${i + 1}');

      // 向这个小组添加玩家
      for (int j = 0;
          j < playersInThisGroup && playerIndex < totalPlayers;
          j++) {
        group = group.addPlayer(players[playerIndex]);
        playerIndex++;
      }

      populatedGroups.add(group);
    }

    return populatedGroups;
  }

  // 保存分组到历史记录
  Future<void> _saveToHistory(List<Group> groups) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_savedHistoryKey) ?? [];

      // 创建一个历史记录条目
      final entry = {
        'timestamp': DateTime.now().toIso8601String(),
        'groups': groups.map((g) => g.toJson()).toList(),
      };

      // 添加到历史记录
      history.add(jsonEncode(entry));

      // 限制历史记录大小
      if (history.length > 10) {
        history.removeAt(0);
      }

      await prefs.setStringList(_savedHistoryKey, history);
    } catch (e) {
      // 处理错误
      debugPrint('保存历史记录失败: $e');
    }
  }

  // 获取分组历史记录
  Future<List<Map<String, dynamic>>> getGroupHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_savedHistoryKey) ?? [];

      return history
          .map((entry) => jsonDecode(entry) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('获取历史记录失败: $e');
      return [];
    }
  }

  // 保存当前分组
  Future<bool> saveGroups(List<Group> groups, String saveName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGroups = prefs.getStringList(_savedGroupsKey) ?? [];

      // 创建保存条目
      final saveEntry = {
        'name': saveName,
        'timestamp': DateTime.now().toIso8601String(),
        'groups': groups.map((g) => g.toJson()).toList(),
      };

      // 添加到保存列表
      savedGroups.add(jsonEncode(saveEntry));

      await prefs.setStringList(_savedGroupsKey, savedGroups);
      return true;
    } catch (e) {
      debugPrint('保存分组失败: $e');
      return false;
    }
  }

  // 加载保存的分组
  Future<List<Map<String, dynamic>>> getSavedGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGroups = prefs.getStringList(_savedGroupsKey) ?? [];

      return savedGroups
          .map((entry) => jsonDecode(entry) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('获取保存的分组失败: $e');
      return [];
    }
  }

  // 删除保存的分组
  Future<bool> deleteSavedGroup(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGroups = prefs.getStringList(_savedGroupsKey) ?? [];

      if (index >= 0 && index < savedGroups.length) {
        savedGroups.removeAt(index);
        await prefs.setStringList(_savedGroupsKey, savedGroups);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('删除保存的分组失败: $e');
      return false;
    }
  }

  // 保存常用玩家列表
  Future<bool> savePlayersList(List<Player> players, String listName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPlayers = prefs.getStringList(_savedPlayersKey) ?? [];

      // 创建保存条目
      final saveEntry = {
        'name': listName,
        'timestamp': DateTime.now().toIso8601String(),
        'players': players.map((p) => p.toJson()).toList(),
      };

      // 添加到保存列表
      savedPlayers.add(jsonEncode(saveEntry));

      await prefs.setStringList(_savedPlayersKey, savedPlayers);
      return true;
    } catch (e) {
      debugPrint('保存玩家列表失败: $e');
      return false;
    }
  }

  // 获取保存的玩家列表
  Future<List<Map<String, dynamic>>> getSavedPlayerLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPlayers = prefs.getStringList(_savedPlayersKey) ?? [];

      return savedPlayers
          .map((entry) => jsonDecode(entry) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('获取保存的玩家列表失败: $e');
      return [];
    }
  }

  // 按技能水平平衡小组
  List<Group> balanceGroupsBySkill(List<Group> groups) {
    // 这里可以实现更复杂的平衡算法
    // 目前仅为示例
    return groups;
  }

  // 手动移动玩家到另一个小组
  List<Group> movePlayerToGroup(
    List<Group> groups,
    String playerId,
    String sourceGroupId,
    String targetGroupId,
  ) {
    // 找到源组和目标组
    final sourceGroupIndex = groups.indexWhere((g) => g.id == sourceGroupId);
    final targetGroupIndex = groups.indexWhere((g) => g.id == targetGroupId);

    if (sourceGroupIndex == -1 || targetGroupIndex == -1) {
      return groups; // 未找到组，返回原始列表
    }

    // 找到要移动的玩家
    final sourceGroup = groups[sourceGroupIndex];
    final playerIndex = sourceGroup.players.indexWhere((p) => p.id == playerId);

    if (playerIndex == -1) {
      return groups; // 未找到玩家，返回原始列表
    }

    final player = sourceGroup.players[playerIndex];

    // 创建更新后的组列表
    final updatedGroups = List<Group>.from(groups);

    // 从源组中移除玩家
    updatedGroups[sourceGroupIndex] = sourceGroup.removePlayer(playerId);

    // 将玩家添加到目标组
    updatedGroups[targetGroupIndex] = groups[targetGroupIndex].addPlayer(
      player,
    );

    return updatedGroups;
  }
}
