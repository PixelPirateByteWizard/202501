import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_role.dart';

class CustomRoleService {
  static const String _customRolesKey = 'custom_ai_roles';
  static CustomRoleService? _instance;
  
  CustomRoleService._();
  
  static CustomRoleService get instance {
    _instance ??= CustomRoleService._();
    return _instance!;
  }

  // 获取所有自定义角色
  Future<List<AIRole>> getCustomRoles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rolesJson = prefs.getStringList(_customRolesKey) ?? [];
      
      return rolesJson.map((roleStr) {
        final roleMap = jsonDecode(roleStr) as Map<String, dynamic>;
        return AIRole.fromJson(roleMap);
      }).toList();
    } catch (e) {
      print('Error loading custom roles: $e');
      return [];
    }
  }

  // 保存自定义角色
  Future<bool> saveCustomRole(AIRole role) async {
    try {
      final customRoles = await getCustomRoles();
      
      // 检查是否已存在同名角色
      if (customRoles.any((r) => r.name == role.name)) {
        return false; // 角色名已存在
      }
      
      // 添加新角色
      final newRole = role.copyWith(isCustom: true);
      customRoles.add(newRole);
      
      // 保存到本地存储
      final prefs = await SharedPreferences.getInstance();
      final rolesJson = customRoles.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_customRolesKey, rolesJson);
      
      return true;
    } catch (e) {
      print('Error saving custom role: $e');
      return false;
    }
  }

  // 删除自定义角色
  Future<bool> deleteCustomRole(int roleId) async {
    try {
      final customRoles = await getCustomRoles();
      customRoles.removeWhere((role) => role.id == roleId);
      
      final prefs = await SharedPreferences.getInstance();
      final rolesJson = customRoles.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_customRolesKey, rolesJson);
      
      return true;
    } catch (e) {
      print('Error deleting custom role: $e');
      return false;
    }
  }

  // 更新自定义角色
  Future<bool> updateCustomRole(AIRole updatedRole) async {
    try {
      final customRoles = await getCustomRoles();
      final index = customRoles.indexWhere((role) => role.id == updatedRole.id);
      
      if (index == -1) return false;
      
      customRoles[index] = updatedRole.copyWith(isCustom: true);
      
      final prefs = await SharedPreferences.getInstance();
      final rolesJson = customRoles.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_customRolesKey, rolesJson);
      
      return true;
    } catch (e) {
      print('Error updating custom role: $e');
      return false;
    }
  }

  // 获取所有角色（预设 + 自定义）
  Future<List<AIRole>> getAllRoles() async {
    final presetRoles = AIRole.getAllRoles();
    final customRoles = await getCustomRoles();
    
    return [...presetRoles, ...customRoles];
  }
}