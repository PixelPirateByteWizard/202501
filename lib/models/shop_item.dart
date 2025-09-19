import 'package:flutter/material.dart';
import 'item.dart';

class ShopItem {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final int price;
  final Map<String, int> stats;
  final String icon;
  final int stock; // 库存，-1表示无限
  final bool isLimited; // 是否限时商品
  final String rarity; // 稀有度：common, rare, epic, legendary

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    required this.stats,
    required this.icon,
    this.stock = -1,
    this.isLimited = false,
    this.rarity = 'common',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'price': price,
      'stats': stats,
      'icon': icon,
      'stock': stock,
      'isLimited': isLimited,
      'rarity': rarity,
    };
  }

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: ItemType.values[json['type']],
      price: json['price'],
      stats: Map<String, int>.from(json['stats']),
      icon: json['icon'],
      stock: json['stock'] ?? -1,
      isLimited: json['isLimited'] ?? false,
      rarity: json['rarity'] ?? 'common',
    );
  }

  ShopItem copyWith({
    String? id,
    String? name,
    String? description,
    ItemType? type,
    int? price,
    Map<String, int>? stats,
    String? icon,
    int? stock,
    bool? isLimited,
    String? rarity,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      price: price ?? this.price,
      stats: stats ?? this.stats,
      icon: icon ?? this.icon,
      stock: stock ?? this.stock,
      isLimited: isLimited ?? this.isLimited,
      rarity: rarity ?? this.rarity,
    );
  }

  // 转换为背包物品
  Item toInventoryItem({int quantity = 1}) {
    return Item(
      id: id,
      name: name,
      description: description,
      type: type,
      quantity: quantity,
      stats: stats,
      icon: icon,
    );
  }

  // 获取稀有度颜色
  Color getRarityColor() {
    switch (rarity) {
      case 'common':
        return const Color(0xFF9E9E9E); // 灰色
      case 'rare':
        return const Color(0xFF2196F3); // 蓝色
      case 'epic':
        return const Color(0xFF9C27B0); // 紫色
      case 'legendary':
        return const Color(0xFFFF9800); // 橙色
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  // 获取稀有度名称
  String getRarityName() {
    switch (rarity) {
      case 'common':
        return '普通';
      case 'rare':
        return '稀有';
      case 'epic':
        return '史诗';
      case 'legendary':
        return '传说';
      default:
        return '普通';
    }
  }
}

// 商店购买记录
class PurchaseRecord {
  final String itemId;
  final int quantity;
  final int totalPrice;
  final DateTime purchaseTime;

  PurchaseRecord({
    required this.itemId,
    required this.quantity,
    required this.totalPrice,
    required this.purchaseTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'purchaseTime': purchaseTime.millisecondsSinceEpoch,
    };
  }

  factory PurchaseRecord.fromJson(Map<String, dynamic> json) {
    return PurchaseRecord(
      itemId: json['itemId'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      purchaseTime: DateTime.fromMillisecondsSinceEpoch(json['purchaseTime']),
    );
  }
}