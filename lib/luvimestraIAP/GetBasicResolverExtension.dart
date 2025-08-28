class OffsetUnsortedRotationFactory {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const OffsetUnsortedRotationFactory({
    required this.itemId,
    required this.name,
    required this.type,
    required this.coinAmount,
    required this.price,
    required this.description,
    required this.locale,
    required this.category,
  });
}

const List<OffsetUnsortedRotationFactory> shopInventory = <OffsetUnsortedRotationFactory>[
  OffsetUnsortedRotationFactory(
    itemId: '0001',
    name: '新手套餐',
    type: 'basic',
    coinAmount: 100,
    price: '¥10',
    description: '新手专享优惠',
    locale: 'zh_CN',
    category: 'basic',
  ),
  OffsetUnsortedRotationFactory(
    itemId: '0002',
    name: '超值套餐',
    type: 'basic',
    coinAmount: 300,
    price: '¥30',
    description: '性价比之选',
    locale: 'zh_CN',
    category: 'basic',
  ),
  OffsetUnsortedRotationFactory(
    itemId: '0003',
    name: '高级套餐',
    type: 'basic',
    coinAmount: 980,
    price: '¥98',
    description: '最受欢迎选择',
    locale: 'zh_CN',
    category: 'basic',
  ),
  OffsetUnsortedRotationFactory(
    itemId: '0004',
    name: '至尊套餐',
    type: 'basic',
    coinAmount: 2980,
    price: '¥298',
    description: '超值大礼包',
    locale: 'zh_CN',
    category: 'basic',
  ),
  OffsetUnsortedRotationFactory(
    itemId: '0005',
    name: '豪华套餐',
    type: 'basic',
    coinAmount: 5980,
    price: '¥598',
    description: '终极游戏体验',
    locale: 'zh_CN',
    category: 'basic',
  ),
];
