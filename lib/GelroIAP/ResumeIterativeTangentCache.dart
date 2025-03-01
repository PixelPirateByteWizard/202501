class RespondNewestParameterCollection {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const RespondNewestParameterCollection({
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

const List<RespondNewestParameterCollection> shopInventory = <RespondNewestParameterCollection>[
  // 常规商品
  RespondNewestParameterCollection(
    itemId: '580400',
    name: 'One gift box',
    type: 'basic',
    coinAmount: 100,
    price: '0.99',
    description: 'One gift box',
    locale: 'en_US',
    category: 'basic',
  ),
  RespondNewestParameterCollection(
    itemId: '580401',
    name: 'Small gift box',
    type: 'basic',
    coinAmount: 500,
    price: '4.99',
    description: 'Small gift box',
    locale: 'en_US',
    category: 'basic',
  ),
  RespondNewestParameterCollection(
    itemId: '580402',
    name: 'Large gift box',
    type: 'basic',
    coinAmount: 1200,
    price: '9.99',
    description: 'Large gift box',
    locale: 'en_US',
    category: 'basic',
  ),
  RespondNewestParameterCollection(
    itemId: '580403',
    name: 'Pile of gift boxes',
    type: 'basic',
    coinAmount: 2500,
    price: '19.99',
    description: 'Pile of gift boxes',
    locale: 'en_US',
    category: 'basic',
  ),
  RespondNewestParameterCollection(
    itemId: '580404',
    name: 'Car gift box',
    type: 'basic',
    coinAmount: 7000,
    price: '49.99',
    description: 'Car gift box',
    locale: 'en_US',
    category: 'basic',
  ),
  RespondNewestParameterCollection(
    itemId: '580405',
    name: 'House gift box',
    type: 'basic',
    coinAmount: 15000,
    price: '99.99',
    description: 'House gift box',
    locale: 'en_US',
    category: 'basic',
  ),
  
  // 促销商品
  RespondNewestParameterCollection(
    itemId: '580406',
    name: 'Small gift box[Big deals]',
    type: 'promotion',
    coinAmount: 500,
    price: '1.99',
    description: 'Small gift box[Big deals]',
    locale: 'en_US',
    category: 'promotion',
  ),
  RespondNewestParameterCollection(
    itemId: '580407',
    name: 'Large gift box[Big deals]',
    type: 'promotion',
    coinAmount: 1200,
    price: '4.99',
    description: 'Large gift box[Big deals]',
    locale: 'en_US',
    category: 'promotion',
  ),
  RespondNewestParameterCollection(
    itemId: '580408',
    name: 'Pile of gift boxes[Big deals]',
    type: 'promotion',
    coinAmount: 2500,
    price: '11.99',
    description: 'Pile of gift boxes[Big deals]',
    locale: 'en_US',
    category: 'promotion',
  ),
  RespondNewestParameterCollection(
    itemId: '580409',
    name: 'Car gift box[Big deals]',
    type: 'promotion',
    coinAmount: 7000,
    price: '34.99',
    description: 'Car gift box[Big deals]',
    locale: 'en_US',
    category: 'promotion',
  ),
  RespondNewestParameterCollection(
    itemId: '580410',
    name: 'House gift box[Big deals]',
    type: 'promotion',
    coinAmount: 15000,
    price: '79.99',
    description: 'House gift box[Big deals]',
    locale: 'en_US',
    category: 'promotion',
  ),
];
