Astrelexis App - Flutter 开发文档
1. 项目概述
Astrelexis 是一款结合了日记、待办事项（To-Do）和数据统计的个人效率与生活记录应用。其设计灵感来源于星空和宇宙，旨在为用户提供一个宁静、优雅且功能强大的私人空间。

核心功能：

日记 (Journal): 按日期创建和管理日记条目，支持图文混排。

待办事项 (To-Do): 创建、管理和跟踪任务。

记忆 (Memory): 以图片为主的快速记录方式。

统计 (Statistics): 通过热力图和图表直观展示用户活动和情绪。

AI 助手 (Astra): 一个用于未来扩展的交互式 AI 界面。

设置 (Settings): 提供应用信息和相关协议链接。

技术栈约束：

状态管理: setState

数据存储: shared_preferences

模型: 手动编写 toJson/fromJson，不使用 freezed 或 part 语法。

资源: 不使用本地图片资源 (assets/images) 或第三方网络图片缓存库 (cached_network_image)。

字体: 使用系统默认字体。

用户系统: 无需账户功能。

2. 应用架构
为了实现低耦合和高可维护性，我们采用分层架构设计，将应用分为 UI 层、业务逻辑层 和 数据持久层。

UI (View) 层: 负责界面的展示和用户交互。包含所有的屏幕（Screens）和可复用的组件（Widgets）。此层级不直接处理业务逻辑或数据存储，仅通过调用服务层来获取数据和触发操作。

业务逻辑 (Service) 层: 负责处理应用的业务逻辑。例如，数据的增删改查、状态管理等。这一层是 UI 和数据存储之间的桥梁。

数据 (Model & Data Persistence) 层: 负责定义数据结构（Models）和具体的数据存储实现。shared_preferences 的所有读写操作都将被封装在这一层中。

这种分离确保了 UI 的变更不会影响到底层的数据存储，反之亦然。

3. 文件结构
lib/
├── main.dart                 # App 入口
|
├── screens/                  # 主页面
│   ├── main_screen.dart      # 主框架 (包含底部导航栏)
│   ├── journal/
│   │   └── journal_screen.dart
│   ├── statistics/
│   │   └── statistics_screen.dart
│   ├── astra/
│   │   └── astra_screen.dart
│   └── settings/
│       └── settings_screen.dart
|
├── widgets/                  # 可复用的 UI 组件
│   ├── glass_card.dart         # 毛玻璃效果卡片
│   ├── fab_menu.dart           # 悬浮按钮和径向菜单
│   ├── mood_heatmap.dart       # 情绪热力图
│   └── goal_progress_bar.dart  # 目标进度条
|
├── models/                   # 数据模型
│   ├── journal_entry.dart      # 日记条目模型
│   └── todo_item.dart          # 待办事项模型
|
├── services/                 # 业务逻辑服务
│   └── storage_service.dart    # 封装 SharedPreferences 的数据存储服务
|
└── utils/                    # 工具和常量
    └── app_colors.dart         # App 全局颜色定义

4. 数据模型定义 (Models)
journal_entry.dart

日记和记忆都可以使用此模型。通过 imageUrl 字段是否为空来区分。

// lib/models/journal_entry.dart

import 'dart:convert';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String? imageUrl; // 用于“记忆”功能，普通日记则为 null
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  // 从 Map 转换
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['imageUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // 转换到 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  // JSON 序列化/反序列化
  String toJson() => json.encode(toMap());
  factory JournalEntry.fromJson(String source) => JournalEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}

todo_item.dart

// lib/models/todo_item.dart

import 'dart:convert';

class TodoItem {
  final String id;
  final String task;
  final String? notes;
  final DateTime dueDate;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.task,
    this.notes,
    required this.dueDate,
    this.isCompleted = false,
  });

  // 从 Map 转换
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'] as String,
      task: map['task'] as String,
      notes: map['notes'] as String?,
      dueDate: DateTime.parse(map['dueDate'] as String),
      isCompleted: map['isCompleted'] as bool,
    );
  }

  // 转换到 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'notes': notes,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // JSON 序列化/反序列化
  String toJson() => json.encode(toMap());
  factory TodoItem.fromJson(String source) => TodoItem.fromMap(json.decode(source) as Map<String, dynamic>);
}

5. 实现计划 (Implementation Plan)
阶段一：项目基础与核心 UI 搭建

项目初始化: 创建新的 Flutter 项目，设置 main.dart。

主题与常量: 在 utils/app_colors.dart 中定义 App 的主色调（#2E1A47 等）。在 main.dart 的 MaterialApp 中配置全局主题。

主导航框架 (main_screen.dart):

创建一个 StatefulWidget。

使用 Scaffold 和 BottomNavigationBar 实现底部四个 Tab 的切换。

页面主体使用 PageView 或 IndexedStack 来承载四个主屏幕。

静态页面构建:

创建 JournalScreen, StatisticsScreen, AstraScreen, SettingsScreen 的静态 UI 骨架，确保布局和原型一致。

SettingsScreen: 直接实现为静态列表，包含“关于我们”等条目，每个条目使用 ListTile，并带有向右箭头图标。

可复用组件 (widgets/):

创建 glass_card.dart，使用 BackdropFilter 和 Container 实现毛玻璃效果。

阶段二：数据存储与日记功能

数据存储服务 (storage_service.dart):

创建 StorageService 类。

封装 shared_preferences，提供方法如 Future<void> saveEntries(List<JournalEntry> entries) 和 Future<List<JournalEntry>> loadEntries()。

关键点: 数据列表将通过 json.encode 转换为 JSON 字符串后存储，读取时再通过 json.decode 解析。

添加功能子页面:

实现原型中的 sub-page-overlay 效果。这可以通过 showModalBottomSheet 或 Navigator.push 一个自定义路由（PageRouteBuilder）来实现从底部滑入的全屏页面。

创建“添加日记/待办/记忆”的表单页面。

JournalScreen 功能实现:

在 JournalScreen 中创建一个 List<JournalEntry> 来保存状态。

在 initState 中，调用 StorageService 加载数据，并通过 setState 更新 UI。

当用户通过添加页面保存新条目时，调用 StorageService 保存完整列表，并用 setState 刷新当前屏幕。

使用 ListView.builder 和 ExpansionTile (或自定义的 details 效果) 来展示按天折叠的日记列表。

阶段三：统计页面功能

StatisticsScreen 数据处理:

在 StatisticsScreen 的 initState 中，从 StorageService 加载所有 JournalEntry 数据。

情绪热力图 (mood_heatmap.dart):

创建一个 Widget，接收日记数据。

根据数据计算出每天的“活跃度”（例如，当天有条目即为 1），并将其映射到不同的颜色强度。

使用 GridView 来渲染热力图的方块。

其他图表:

实现“活动日志”和“目标进度”的静态 UI。在 setState 中根据加载的数据更新图表显示。

阶段四：完善与收尾

悬浮按钮 (fab_menu.dart):

创建一个 StatefulWidget 来管理悬浮按钮和径向菜单的显示状态。

使用 Stack 布局将 FAB 和菜单覆盖在主屏幕之上。

点击 FAB 时，通过 setState 改变状态，播放动画并显示/隐藏菜单项。

AstraScreen:

实现静态聊天界面，作为未来功能的占位符。

交互与动画:

优化页面切换、列表加载和菜单展开的动画效果，使其更流畅。

代码审查与重构:

检查代码，确保遵循低耦合原则，移除不必要的依赖。

