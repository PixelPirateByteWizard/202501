// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstrumentMessage _$InstrumentMessageFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['type', 'content', 'timestamp'],
  );
  return InstrumentMessage(
    type: json['type'] as String,
    content: json['content'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

Map<String, dynamic> _$InstrumentMessageToJson(InstrumentMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
    };

Friend _$FriendFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'name',
      'avatarAsset',
      'musicExperience',
      'practiceFrequency',
      'lastActive'
    ],
  );
  return Friend(
    id: json['id'] as String,
    name: json['name'] as String,
    avatarAsset: json['avatarAsset'] as String,
    bio: json['bio'] as String? ?? '',
    mainInstrument: (json['mainInstrument'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    musicExperience: (json['musicExperience'] as num).toInt(),
    favoriteGenres: (json['favoriteGenres'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    practiceFrequency: json['practiceFrequency'] as String,
    isOnline: json['isOnline'] as bool? ?? false,
    lastActive: DateTime.parse(json['lastActive'] as String),
    instrumentAssets: (json['instrumentAssets'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    instrumentMessages: (json['instrumentMessages'] as List<dynamic>?)
            ?.map((e) => InstrumentMessage.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatarAsset': instance.avatarAsset,
      'bio': instance.bio,
      'mainInstrument': instance.mainInstrument,
      'musicExperience': instance.musicExperience,
      'favoriteGenres': instance.favoriteGenres,
      'practiceFrequency': instance.practiceFrequency,
      'isOnline': instance.isOnline,
      'lastActive': instance.lastActive.toIso8601String(),
      'instrumentAssets': instance.instrumentAssets,
      'instrumentMessages': instance.instrumentMessages,
    };
