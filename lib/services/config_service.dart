import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RemoteConfigService {
  final String configUrl;

  RemoteConfigService({required this.configUrl});

  Future<Map<String, dynamic>?> fetchConfig() async {
    try {
      final uri = Uri.parse(configUrl);
      final resp = await http.get(uri, headers: {
        'user-agent':
            'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
        'accept': 'application/json',
      });
      if (resp.statusCode == 200 && resp.body.isNotEmpty) {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }
    } catch (_) {}
    return null;
  }
}

class MarketConfig {
  final List<ExchangeActivityConfig> activities;
  final List<HotExchangeConfig> hotExchanges;

  MarketConfig({required this.activities, required this.hotExchanges});

  factory MarketConfig.fromJson(Map<String, dynamic> json) {
    final activities = (json['exchangeActivities'] as List<dynamic>? ?? [])
        .map((e) => ExchangeActivityConfig.fromJson(e as Map<String, dynamic>))
        .toList();
    final hotExchanges = (json['hotExchanges'] as List<dynamic>? ?? [])
        .map((e) => HotExchangeConfig.fromJson(e as Map<String, dynamic>))
        .toList();
    return MarketConfig(activities: activities, hotExchanges: hotExchanges);
  }
}

class ExchangeActivityConfig {
  final String exchangeName;
  final String title;
  final String description;
  final String endDateText;
  final String buttonText;
  final String url;

  ExchangeActivityConfig({
    required this.exchangeName,
    required this.title,
    required this.description,
    required this.endDateText,
    required this.buttonText,
    required this.url,
  });

  factory ExchangeActivityConfig.fromJson(Map<String, dynamic> json) {
    return ExchangeActivityConfig(
      exchangeName: json['exchangeName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      endDateText: json['endDateText'] as String? ?? '',
      buttonText: json['buttonText'] as String? ?? '立即前往',
      url: json['url'] as String? ?? '',
    );
  }
}

class HotExchangeConfig {
  final String name;
  final String description;
  final List<ExchangeStatConfig> stats;
  final List<String> features;
  final String buttonText;
  final String url;
  final String? logoUrl;

  HotExchangeConfig({
    required this.name,
    required this.description,
    required this.stats,
    required this.features,
    required this.buttonText,
    required this.url,
    this.logoUrl,
  });

  factory HotExchangeConfig.fromJson(Map<String, dynamic> json) {
    final stats = (json['stats'] as List<dynamic>? ?? [])
        .map((e) => ExchangeStatConfig.fromJson(e as Map<String, dynamic>))
        .toList();
    final features = (json['features'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    return HotExchangeConfig(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      stats: stats,
      features: features,
      buttonText: json['buttonText'] as String? ?? '前往',
      url: json['url'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
    );
  }
}

class ExchangeStatConfig {
  final String title;
  final String value;
  final String icon; // semantic icon name

  ExchangeStatConfig({required this.title, required this.value, required this.icon});

  factory ExchangeStatConfig.fromJson(Map<String, dynamic> json) {
    return ExchangeStatConfig(
      title: json['title'] as String? ?? '',
      value: json['value'] as String? ?? '',
      icon: json['icon'] as String? ?? 'bar_chart',
    );
  }
}

IconData mapIcon(String name) {
  switch (name) {
    case 'bar_chart':
      return Icons.bar_chart;
    case 'currency_exchange':
      return Icons.currency_exchange;
    case 'people':
      return Icons.people;
    case 'rocket':
      return Icons.rocket_launch;
    default:
      return Icons.bar_chart;
  }
}

