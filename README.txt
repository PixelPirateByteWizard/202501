CoinVerse (币域) App - Flutter 开发文档
1. 项目概述
CoinVerse (币域) 是一款专注于加密货币领域的智能资讯与分析应用。其核心价值在于利用AI技术，在海量、嘈杂的市场信息中为用户提炼出清晰、可信的决策信号，帮助用户更高效、更理性地进行投资决策。

本应用旨在终结用户在多个信息源之间频繁切换的痛点，提供一个集行情、资讯、AI分析于一体的一站式情报中心。

2. 核心功能需求
根据产品原型，应用需实现以下核心功能模块：

启动与引导 (Onboarding):

首次启动时展示应用的价值主张。

引导用户完成初始关注币种的选择。

主导航框架 (Main Shell):

包含“仪表盘”、“市场”、“VerseAI”、“资讯”、“我的”五个主标签页。

实现一个带有中心特色按钮的自定义底部导航栏。

仪表盘 (Dashboard):

展示用户关注列表的币种行情。

展示AI每日洞察卡片。

聚合关键新闻流。

市场 (Market):

提供可分类（全部、热门、DeFi等）的全局币种列表。

展示各币种的实时价格、24小时涨跌幅和7日价格趋势图 (Sparkline)。

提供搜索功能。

VerseAI 助手 (AI Assistant):

一个对话式界面，用户可以输入问题。

能够接收问题并展示AI生成的投研报告卡片。

资讯 (Intel Feed):

可分类（精选、快讯、公告）的信息流。

支持多种卡片样式以区分不同类型的资讯。

我的 (Profile):

展示用户基本信息（头像、昵称）。

提供导航入口至：关于我们、用户协议、隐私协议、使用帮助、反馈和建议、设置。

实现上述各个子页面（主要为静态内容展示或简单表单）。

3. 技术选型与架构
为保证项目启动的敏捷性和低耦合性，我们采用以下技术方案：

核心框架: Flutter SDK (不使用外部字体包)

状态管理: setState。在项目初期，所有页面自身的状态将通过 StatefulWidget 和 setState 进行管理。这足以应对当前需求，并保持了代码的直观性。

数据持久化: shared_preferences。用于存储轻量级数据，如：是否已完成首次引导流程、用户关注的币种ID列表等。

网络请求: http 包。一个轻量级、官方推荐的网络请求库，用于与后端API进行通信。

项目架构: 分层架构 (UI - Service - Model)

UI层 (features): 存放所有与界面相关的代码（屏幕、组件）。每个功能模块为一个独立的文件夹。

服务层 (core/services): 处理业务逻辑，如API请求、数据持久化操作。UI层通过调用服务层来获取或提交数据，实现界面与逻辑的分离。

模型层 (core/models): 定义纯粹的Dart数据对象，用于承载从API获取的数据。

4. 项目文件结构与详细实现计划
lib/
├── main.dart                 # App入口
├── app.dart                  # App根组件，配置主题和路由
|
├── core/
│   ├── services/
│   │   ├── api_service.dart      # 封装所有API网络请求
│   │   └── storage_service.dart  # 封装SharedPreferences操作
│   └── models/
│       ├── coin_model.dart       # 币种数据模型
│       ├── news_article_model.dart # 新闻/资讯数据模型
│       └── ai_report_model.dart  # AI报告数据模型
|
├── features/
│   ├── onboarding/
│   │   └── onboarding_screen.dart # 引导页
│   │
│   ├── shell/
│   │   └── main_shell.dart         # 主导航框架 (带底部Tab)
│   │
│   ├── dashboard/
│   │   └── dashboard_screen.dart   # 仪表盘页面
│   │
│   ├── market/
│   │   └── market_screen.dart      # 市场页面
│   │
│   ├── ai_assistant/
│   │   └── ai_assistant_screen.dart # AI助手页面
│   │
│   ├── news/
│   │   └── news_screen.dart        # 资讯页面
│   │
│   └── profile/
│       ├── profile_screen.dart     # “我的”主页
│       ├── about_screen.dart       # “关于我们”子页面
│       └── feedback_screen.dart    # “反馈建议”子页面
│
└── shared/
    └── widgets/
        ├── custom_bottom_nav.dart  # 自定义底部导航栏组件
        ├── themed_card.dart        # 统一风格的卡片组件
        └── loading_indicator.dart  # 统一的加载动画

文件功能详解

main.dart: 程序的起点，初始化服务，并运行 App 组件。

app.dart: MaterialApp 的根。定义App的整体主题（如深色模式、主色调），并决定初始页面是 OnboardingScreen 还是 MainShell。

api_service.dart: 包含获取市场列表、新闻列表、提交AI查询等所有网络请求方法。初期可返回写死的假数据，便于UI开发。

storage_service.dart: 提供 Future<void> setOnboardingComplete()、Future<bool> isOnboardingComplete()、Future<void> saveWatchlist(List<String> ids) 等方法。

onboarding_screen.dart: 一个 StatefulWidget，使用 PageController 实现多页引导。在最后一页点击“完成”时，调用 StorageService 记录状态。

main_shell.dart: 一个 StatefulWidget，管理当前选中的tab索引。主体是一个 Scaffold，其 body 根据索引切换不同的页面，bottomNavigationBar 使用我们自定义的 CustomBottomNav。

dashboard_screen.dart / market_screen.dart / news_screen.dart: 均为 StatefulWidget。在 initState 中调用 ApiService 异步获取数据，在 then 回调中使用 setState 更新UI，并展示 LoadingIndicator。

ai_assistant_screen.dart: 包含一个 TextEditingController 和一个消息列表。点击发送时，将用户消息和加载中的AI消息添加到列表，调用API，获取结果后更新对应的AI消息项。

profile_screen.dart: 主要是一个静态列表，使用 ListTile 或自定义行组件，通过 Navigator.push 跳转到各个子页面。

about_screen.dart / feedback_screen.dart: 简单的 StatefulWidget 页面，用于展示静态信息或提供一个简单的表单。

custom_bottom_nav.dart: 一个独立的 Widget，根据 MainShell 传入的当前索引和回调函数来构建UI和处理点击事件。

5. 模型类定义 (Model Class Definitions)
// file: lib/core/models/coin_model.dart
class Coin {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl; // 直接使用网络URL
  final double price;
  final double priceChange24h;
  final List<double> sparklineData; // 7日价格点位

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.priceChange24h,
    required this.sparklineData,
  });

  // 未来可添加 factory Coin.fromJson(Map<String, dynamic> json)
}

// file: lib/core/models/news_article_model.dart
enum ArticleType { featured, flash, announcement }

class NewsArticle {
  final String id;
  final String title;
  final String source;
  final String? imageUrl; // 快讯可以没有图片
  final DateTime publishedAt;
  final ArticleType type;

  NewsArticle({
    required this.id,
    required this.title,
    required this.source,
    this.imageUrl,
    required this.publishedAt,
    required this.type,
  });
}

// file: lib/core/models/ai_report_model.dart
enum RiskLevel { low, medium, high }

class AIReport {
  final String summary;
  final RiskLevel riskLevel;
  final String pros; // 优势分析
  final String cons; // 风险分析

  AIReport({
    required this.summary,
    required this.riskLevel,
    required this.pros,
    required this.cons,
  });
}

6. 实现关键步骤
步骤一：项目初始化与架构搭建

创建新的Flutter项目。

在 pubspec.yaml 中添加 http 和 shared_preferences 依赖。

按照上述规划，创建完整的文件夹和空的 .dart 文件。

步骤二：构建UI框架

在 app.dart 中定义好 ThemeData。

实现 MainShell 和 CustomBottomNav，确保五个主页面的基本切换逻辑通畅。

步骤三：服务与模型层开发

实现 ApiService，但所有方法暂时返回写死的、符合模型定义的假数据。

完整实现 StorageService 的所有方法。

定义好 Coin, NewsArticle, AIReport 三个模型类。

步骤四：增量式页面开发

首先开发“我的”模块：实现 ProfileScreen 及其所有静态子页面，这是最简单的部分。

开发“市场”和“资讯”：使用 FutureBuilder 或在 initState 中调用服务，获取假数据并用 setState 构建列表UI。

开发“仪表盘”：组合多个数据源的调用，构建复杂的首页布局。

最后开发“AI助手”：处理输入、消息列表更新和异步结果展示的交互逻辑。

步骤五：集成与联调

将 ApiService 中的假数据替换为真实的HTTP请求。

处理加载中、加载失败等网络状态，在UI上给出友好提示。

完成 OnboardingScreen 逻辑，并与 StorageService 联动，实现App的首次启动判断。

进行全面的测试和UI微调。