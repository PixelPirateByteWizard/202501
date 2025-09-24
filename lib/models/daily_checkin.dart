class DailyCheckinReward {
  final int day;
  final String itemImage;
  final String itemName;
  final int quantity;
  final bool isSpecial;

  DailyCheckinReward({
    required this.day,
    required this.itemImage,
    required this.itemName,
    required this.quantity,
    this.isSpecial = false,
  });
}

class DailyCheckinData {
  final List<DailyCheckinReward> rewards;
  final int currentDay;
  final bool hasCheckedToday;
  final DateTime? lastCheckinDate;
  final int consecutiveDays;
  final int totalDays;

  DailyCheckinData({
    required this.rewards,
    required this.currentDay,
    required this.hasCheckedToday,
    this.lastCheckinDate,
    this.consecutiveDays = 0,
    this.totalDays = 0,
  });

  static List<DailyCheckinReward> getDefaultRewards() {
    return [
      DailyCheckinReward(
        day: 1,
        itemImage: 'assets/item/item_1.png',
        itemName: '银币',
        quantity: 100,
      ),
      DailyCheckinReward(
        day: 2,
        itemImage: 'assets/item/item_2.png',
        itemName: '经验丹',
        quantity: 50,
      ),
      DailyCheckinReward(
        day: 3,
        itemImage: 'assets/item/item_3.png',
        itemName: '装备碎片',
        quantity: 10,
      ),
      DailyCheckinReward(
        day: 4,
        itemImage: 'assets/item/item_4.png',
        itemName: '金币',
        quantity: 200,
      ),
      DailyCheckinReward(
        day: 5,
        itemImage: 'assets/item/item_5.png',
        itemName: '强化石',
        quantity: 5,
      ),
      DailyCheckinReward(
        day: 6,
        itemImage: 'assets/item/item_6.png',
        itemName: '高级经验丹',
        quantity: 20,
      ),
      DailyCheckinReward(
        day: 7,
        itemImage: 'assets/item/item_7.png',
        itemName: '神秘宝箱',
        quantity: 1,
        isSpecial: true,
      ),
    ];
  }
}
