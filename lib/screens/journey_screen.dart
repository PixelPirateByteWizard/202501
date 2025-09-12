import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import '../models/general.dart';
import '../services/game_data_service.dart';
import 'battle_screen.dart';

class JourneyScreen extends StatefulWidget {
  final GameState gameState;

  const JourneyScreen({super.key, required this.gameState});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with TickerProviderStateMixin {
  List<BattleStage> _battleStages = [];
  int _currentStageIndex = 0;
  bool _isLoading = false;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeOutQuart,
      ),
    );
    _loadBattleStages();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _loadBattleStages() {
    setState(() {
      _isLoading = true;
    });

    // 根据当前章节加载战斗关卡
    _battleStages = _getBattleStagesForChapter(widget.gameState.currentChapter);
    _currentStageIndex = widget.gameState.currentSection - 1;

    setState(() {
      _isLoading = false;
    });

    // 启动进度动画
    _progressAnimationController.forward();
  }

  List<BattleStage> _getBattleStagesForChapter(int chapter) {
    switch (chapter) {
      case 1: // 乱世初起
        return [
          BattleStage(
            id: '1-1',
            name: '黄巾起义',
            description: '中平元年，张角自称"天公将军"，率领黄巾军起义。你作为朝廷将领，奉命平定叛乱，这是你征战天下的第一步。',
            difficulty: 1,
            enemies: _createEnemyGenerals(['张角', '张宝', '张梁']),
            rewards: BattleRewards(
              experience: 300,
              coins: 500,
              equipment: ['铁剑', '布甲'],
            ),
            isCompleted: false,
            isUnlocked: true,
          ),
          BattleStage(
            id: '1-2',
            name: '讨伐董卓',
            description: '董卓废立皇帝，祸乱朝纲。袁绍号召天下诸侯，十八路大军会盟讨董。你将在这场正义之战中崭露头角。',
            difficulty: 2,
            enemies: _createEnemyGenerals(['董卓', '吕布', '李傕']),
            rewards: BattleRewards(
              experience: 400,
              coins: 800,
              equipment: ['精铁枪', '铁甲'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '1-3',
            name: '虎牢关之战',
            description: '吕布镇守虎牢关，连斩数将，威震诸侯。刘关张三兄弟联手迎战，这场战斗将决定联军的士气。',
            difficulty: 3,
            enemies: _createEnemyGenerals(['吕布', '张辽', '高顺']),
            rewards: BattleRewards(
              experience: 600,
              coins: 1200,
              equipment: ['方天画戟', '赤兔马'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '1-4',
            name: '长沙之战',
            description: '董卓已死，诸侯各怀异心。你南下荆州，遇到长沙太守韩玄麾下猛将黄忠，这将是一场英雄惜英雄的较量。',
            difficulty: 4,
            enemies: _createEnemyGenerals(['黄忠', '韩玄', '魏延']),
            rewards: BattleRewards(
              experience: 800,
              coins: 1500,
              equipment: ['神臂弓', '铁胄'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
        ];
      case 2: // 群雄争霸
        return [
          BattleStage(
            id: '2-1',
            name: '官渡之战',
            description: '建安五年，袁绍率十万大军南下，曹操以少敌多。这场战役将决定北方的统治者，也将改写历史。',
            difficulty: 5,
            enemies: _createEnemyGenerals(['袁绍', '颜良', '文丑']),
            rewards: BattleRewards(
              experience: 1000,
              coins: 2000,
              equipment: ['青龙偃月刀', '的卢'],
            ),
            isCompleted: false,
            isUnlocked: true,
          ),
          BattleStage(
            id: '2-2',
            name: '白马之围',
            description: '袁绍派颜良攻打白马，关羽策马冲阵，万军之中取颜良首级。这一战将奠定关羽"武圣"之名。',
            difficulty: 4,
            enemies: _createEnemyGenerals(['颜良', '淳于琼', '袁谭']),
            rewards: BattleRewards(
              experience: 900,
              coins: 1800,
              equipment: ['汗血宝马', '凤翅紫金冠'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '2-3',
            name: '延津之战',
            description: '文丑为颜良报仇，率军追击。关羽再显神威，斩文丑于马下，河北双雄就此陨落。',
            difficulty: 4,
            enemies: _createEnemyGenerals(['文丑', '袁熙', '高览']),
            rewards: BattleRewards(
              experience: 900,
              coins: 1800,
              equipment: ['青釭剑', '锁子黄金甲'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '2-4',
            name: '仓亭之战',
            description: '袁绍败而不服，再次起兵。曹操亲征，这将是袁绍的最后一战，也是统一北方的关键之役。',
            difficulty: 5,
            enemies: _createEnemyGenerals(['袁绍', '审配', '逢纪']),
            rewards: BattleRewards(
              experience: 1200,
              coins: 2500,
              equipment: ['倚天剑', '乌骓马'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
        ];
      case 3: // 三足鼎立
        return [
          BattleStage(
            id: '3-1',
            name: '赤壁之战',
            description: '建安十三年，曹操南征荆州，意图一统天下。孙刘联盟，火烧赤壁，这场战役将奠定三分天下的格局。',
            difficulty: 6,
            enemies: _createEnemyGenerals(['曹操', '张辽', '徐晃']),
            rewards: BattleRewards(
              experience: 1500,
              coins: 3000,
              equipment: ['七星宝刀', '绝影'],
            ),
            isCompleted: false,
            isUnlocked: true,
          ),
          BattleStage(
            id: '3-2',
            name: '华容道',
            description: '曹操败走华容道，关羽奉命把守。旧情难忘，义重如山，这将是关羽人生中最艰难的选择。',
            difficulty: 5,
            enemies: _createEnemyGenerals(['曹操', '张郃', '许褚']),
            rewards: BattleRewards(
              experience: 1300,
              coins: 2800,
              equipment: ['护心镜', '追风马'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '3-3',
            name: '南郡争夺',
            description: '赤壁之后，刘备与孙权争夺南郡。周瑜与诸葛亮斗智斗勇，这场较量将决定荆州的归属。',
            difficulty: 6,
            enemies: _createEnemyGenerals(['周瑜', '程普', '黄盖']),
            rewards: BattleRewards(
              experience: 1400,
              coins: 2900,
              equipment: ['羽扇纶巾', '火攻船'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '3-4',
            name: '入川之战',
            description: '刘备应刘璋之邀入川，但很快反目成仇。庞统献计取成都，这将是刘备建立蜀汉的关键一步。',
            difficulty: 7,
            enemies: _createEnemyGenerals(['刘璋', '张任', '严颜']),
            rewards: BattleRewards(
              experience: 1600,
              coins: 3200,
              equipment: ['诸葛连弩', '蜀锦战袍'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
        ];
      case 4: // 汉中争夺
        return [
          BattleStage(
            id: '4-1',
            name: '定军山之战',
            description: '刘备进军汉中，黄忠刀劈夏侯渊，老将军威震定军山。这一战将为刘备夺取汉中奠定基础。',
            difficulty: 7,
            enemies: _createEnemyGenerals(['夏侯渊', '张郃', '徐晃']),
            rewards: BattleRewards(
              experience: 1800,
              coins: 3500,
              equipment: ['开山刀', '定军山令'],
            ),
            isCompleted: false,
            isUnlocked: true,
          ),
          BattleStage(
            id: '4-2',
            name: '汉水之战',
            description: '曹操亲征汉中，与刘备隔汉水对峙。赵云单骑救主，空营计退敌，展现了常山赵子龙的无双勇武。',
            difficulty: 8,
            enemies: _createEnemyGenerals(['曹操', '曹真', '夏侯惇']),
            rewards: BattleRewards(
              experience: 2000,
              coins: 4000,
              equipment: ['龙胆亮银枪', '白龙马'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '4-3',
            name: '襄樊之战',
            description: '关羽北伐襄樊，水淹七军，威震华夏。这是关羽军事生涯的巅峰，也是蜀汉最接近统一的时刻。',
            difficulty: 8,
            enemies: _createEnemyGenerals(['曹仁', '于禁', '庞德']),
            rewards: BattleRewards(
              experience: 2100,
              coins: 4200,
              equipment: ['春秋刀', '赤兔马鞍'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '4-4',
            name: '麦城之围',
            description: '吕蒙白衣渡江，关羽败走麦城。一代武圣即将陨落，这将改变整个三国的格局。',
            difficulty: 9,
            enemies: _createEnemyGenerals(['吕蒙', '陆逊', '朱然']),
            rewards: BattleRewards(
              experience: 2200,
              coins: 4500,
              equipment: ['武圣遗刀', '忠义之魂'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
        ];
      case 5: // 蜀汉兴衰
        return [
          BattleStage(
            id: '5-1',
            name: '夷陵之战',
            description: '刘备为关羽报仇，倾国之兵伐吴。陆逊火烧连营，蜀汉元气大伤，这将是刘备人生的最后一战。',
            difficulty: 9,
            enemies: _createEnemyGenerals(['陆逊', '朱桓', '韩当']),
            rewards: BattleRewards(
              experience: 2500,
              coins: 5000,
              equipment: ['火攻秘籍', '连环甲'],
            ),
            isCompleted: false,
            isUnlocked: true,
          ),
          BattleStage(
            id: '5-2',
            name: '南蛮征伐',
            description: '诸葛亮南征孟获，七擒七纵，以德服人。这场战役将稳定蜀汉后方，为北伐做准备。',
            difficulty: 7,
            enemies: _createEnemyGenerals(['孟获', '祝融', '兀突骨']),
            rewards: BattleRewards(
              experience: 2200,
              coins: 4500,
              equipment: ['藤甲', '南蛮象兵'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '5-3',
            name: '街亭之战',
            description: '诸葛亮首次北伐，马谡失守街亭。千古名相挥泪斩马谡，这将是北伐路上的第一次挫折。',
            difficulty: 8,
            enemies: _createEnemyGenerals(['张郃', '司马懿', '郭淮']),
            rewards: BattleRewards(
              experience: 2300,
              coins: 4800,
              equipment: ['兵法残卷', '战略地图'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '5-4',
            name: '五丈原',
            description: '诸葛亮最后一次北伐，与司马懿对峙五丈原。秋风五丈原，丞相归天，蜀汉从此走向衰落。',
            difficulty: 10,
            enemies: _createEnemyGenerals(['司马懿', '司马师', '邓艾']),
            rewards: BattleRewards(
              experience: 3000,
              coins: 6000,
              equipment: ['八阵图', '孔明灯'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
        ];
      case 6: // 司马当道
        return [
          BattleStage(
            id: '6-1',
            name: '高平陵之变',
            description: '司马懿发动政变，诛杀曹爽集团。这场不见血的政变将彻底改变魏国的政治格局。',
            difficulty: 8,
            enemies: _createEnemyGenerals(['曹爽', '何晏', '丁谧']),
            rewards: BattleRewards(
              experience: 2800,
              coins: 5500,
              equipment: ['权谋秘籍', '司马印'],
            ),
            isCompleted: false,
            isUnlocked: true,
          ),
          BattleStage(
            id: '6-2',
            name: '淮南三叛',
            description: '王凌、毌丘俭、诸葛诞先后起兵反司马氏。司马师、司马昭兄弟联手平叛，巩固司马氏的统治。',
            difficulty: 9,
            enemies: _createEnemyGenerals(['诸葛诞', '文钦', '唐咨']),
            rewards: BattleRewards(
              experience: 2900,
              coins: 5800,
              equipment: ['平叛令', '司马战旗'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '6-3',
            name: '剑阁之战',
            description: '邓艾偷渡阴平，直取成都。姜维据守剑阁，但已无力回天，蜀汉即将灭亡。',
            difficulty: 10,
            enemies: _createEnemyGenerals(['邓艾', '钟会', '胡烈']),
            rewards: BattleRewards(
              experience: 3200,
              coins: 6500,
              equipment: ['阴平小道图', '破蜀令'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '6-4',
            name: '成都陷落',
            description: '刘禅开城投降，蜀汉灭亡。四十三年的蜀汉政权就此终结，三国鼎立的格局被打破。',
            difficulty: 9,
            enemies: _createEnemyGenerals(['刘禅', '诸葛瞻', '张翼']),
            rewards: BattleRewards(
              experience: 3000,
              coins: 6000,
              equipment: ['传国玉玺', '蜀汉遗宝'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
        ];
      case 7: // 天下归晋
        return [
          BattleStage(
            id: '7-1',
            name: '晋灭吴之战',
            description: '司马炎建立西晋后，决心完成统一大业。王濬楼船下益州，这将是三国时代的最后一战。',
            difficulty: 10,
            enemies: _createEnemyGenerals(['孙皓', '陆抗', '张悌']),
            rewards: BattleRewards(
              experience: 3500,
              coins: 7000,
              equipment: ['统一天下令', '晋朝龙袍'],
            ),
            isCompleted: false,
            isUnlocked: true,
          ),
          BattleStage(
            id: '7-2',
            name: '石头城之围',
            description: '晋军兵临石头城下，孙吴最后的堡垒即将陷落。三国时代即将落下帷幕。',
            difficulty: 9,
            enemies: _createEnemyGenerals(['孙皓', '沈莹', '诸葛靓']),
            rewards: BattleRewards(
              experience: 3300,
              coins: 6800,
              equipment: ['石头城钥匙', '吴国宝剑'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '7-3',
            name: '建业陷落',
            description: '孙皓出降，东吴灭亡。历时九十年的三国时代正式结束，天下重归一统。',
            difficulty: 8,
            enemies: _createEnemyGenerals(['孙皓', '岑昏', '楼玄']),
            rewards: BattleRewards(
              experience: 3000,
              coins: 6500,
              equipment: ['东吴印玺', '统一纪念章'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
          BattleStage(
            id: '7-4',
            name: '天下一统',
            description: '西晋统一天下，三国归晋。你见证了这个波澜壮阔的时代，也在历史的长河中留下了自己的足迹。',
            difficulty: 11,
            enemies: _createEnemyGenerals(['司马炎', '羊祜', '杜预']),
            rewards: BattleRewards(
              experience: 5000,
              coins: 10000,
              equipment: ['三国英雄谱', '历史见证者'],
            ),
            isCompleted: false,
            isUnlocked: false,
          ),
        ];
      default:
        return [];
    }
  }

  List<General> _createEnemyGenerals(List<String> names) {
    final Map<String, Map<String, dynamic>> enemyData = {
      // 黄巾军
      '张角': {
        'avatar': '角',
        'rarity': 3,
        'stats': GeneralStats(
          force: 60,
          intelligence: 85,
          leadership: 80,
          speed: 6,
          troops: 2000,
        ),
        'position': '谋士',
      },
      '张宝': {
        'avatar': '宝',
        'rarity': 2,
        'stats': GeneralStats(
          force: 70,
          intelligence: 75,
          leadership: 65,
          speed: 7,
          troops: 1800,
        ),
        'position': '前锋',
      },
      '张梁': {
        'avatar': '梁',
        'rarity': 2,
        'stats': GeneralStats(
          force: 75,
          intelligence: 60,
          leadership: 70,
          speed: 8,
          troops: 1800,
        ),
        'position': '前锋',
      },

      // 董卓集团
      '董卓': {
        'avatar': '董',
        'rarity': 4,
        'stats': GeneralStats(
          force: 80,
          intelligence: 70,
          leadership: 90,
          speed: 5,
          troops: 3000,
        ),
        'position': '统帅',
      },
      '吕布': {
        'avatar': '吕',
        'rarity': 5,
        'stats': GeneralStats(
          force: 100,
          intelligence: 45,
          leadership: 75,
          speed: 15,
          troops: 2500,
        ),
        'position': '前锋',
      },
      '李傕': {
        'avatar': '傕',
        'rarity': 2,
        'stats': GeneralStats(
          force: 75,
          intelligence: 55,
          leadership: 65,
          speed: 7,
          troops: 1500,
        ),
        'position': '前锋',
      },
      '张辽': {
        'avatar': '辽',
        'rarity': 4,
        'stats': GeneralStats(
          force: 90,
          intelligence: 70,
          leadership: 88,
          speed: 12,
          troops: 2000,
        ),
        'position': '前锋',
      },
      '高顺': {
        'avatar': '顺',
        'rarity': 3,
        'stats': GeneralStats(
          force: 85,
          intelligence: 65,
          leadership: 85,
          speed: 8,
          troops: 1800,
        ),
        'position': '前锋',
      },

      // 荆州武将
      '黄忠': {
        'avatar': '忠',
        'rarity': 4,
        'stats': GeneralStats(
          force: 95,
          intelligence: 65,
          leadership: 80,
          speed: 7,
          troops: 2200,
        ),
        'position': '前锋',
      },
      '韩玄': {
        'avatar': '玄',
        'rarity': 2,
        'stats': GeneralStats(
          force: 60,
          intelligence: 70,
          leadership: 75,
          speed: 5,
          troops: 1800,
        ),
        'position': '统帅',
      },
      '魏延': {
        'avatar': '延',
        'rarity': 3,
        'stats': GeneralStats(
          force: 88,
          intelligence: 60,
          leadership: 75,
          speed: 10,
          troops: 2000,
        ),
        'position': '前锋',
      },

      // 袁绍集团
      '袁绍': {
        'avatar': '绍',
        'rarity': 4,
        'stats': GeneralStats(
          force: 75,
          intelligence: 60,
          leadership: 95,
          speed: 6,
          troops: 3000,
        ),
        'position': '统帅',
      },
      '颜良': {
        'avatar': '良',
        'rarity': 3,
        'stats': GeneralStats(
          force: 95,
          intelligence: 45,
          leadership: 70,
          speed: 8,
          troops: 2200,
        ),
        'position': '前锋',
      },
      '文丑': {
        'avatar': '丑',
        'rarity': 3,
        'stats': GeneralStats(
          force: 92,
          intelligence: 50,
          leadership: 68,
          speed: 9,
          troops: 2000,
        ),
        'position': '前锋',
      },
      '淳于琼': {
        'avatar': '琼',
        'rarity': 2,
        'stats': GeneralStats(
          force: 70,
          intelligence: 55,
          leadership: 60,
          speed: 6,
          troops: 1500,
        ),
        'position': '前锋',
      },
      '袁谭': {
        'avatar': '谭',
        'rarity': 3,
        'stats': GeneralStats(
          force: 75,
          intelligence: 65,
          leadership: 80,
          speed: 7,
          troops: 2000,
        ),
        'position': '统帅',
      },
      '袁熙': {
        'avatar': '熙',
        'rarity': 2,
        'stats': GeneralStats(
          force: 70,
          intelligence: 60,
          leadership: 70,
          speed: 6,
          troops: 1800,
        ),
        'position': '统帅',
      },
      '高览': {
        'avatar': '览',
        'rarity': 3,
        'stats': GeneralStats(
          force: 85,
          intelligence: 55,
          leadership: 70,
          speed: 8,
          troops: 1800,
        ),
        'position': '前锋',
      },
      '审配': {
        'avatar': '配',
        'rarity': 3,
        'stats': GeneralStats(
          force: 65,
          intelligence: 85,
          leadership: 80,
          speed: 5,
          troops: 1800,
        ),
        'position': '谋士',
      },
      '逢纪': {
        'avatar': '纪',
        'rarity': 2,
        'stats': GeneralStats(
          force: 50,
          intelligence: 80,
          leadership: 70,
          speed: 5,
          troops: 1500,
        ),
        'position': '谋士',
      },

      // 曹操集团
      '曹操': {
        'avatar': '操',
        'rarity': 5,
        'stats': GeneralStats(
          force: 85,
          intelligence: 95,
          leadership: 98,
          speed: 10,
          troops: 3500,
        ),
        'position': '统帅',
      },
      '徐晃': {
        'avatar': '晃',
        'rarity': 4,
        'stats': GeneralStats(
          force: 88,
          intelligence: 70,
          leadership: 82,
          speed: 9,
          troops: 2000,
        ),
        'position': '前锋',
      },
      '张郃': {
        'avatar': '郃',
        'rarity': 4,
        'stats': GeneralStats(
          force: 85,
          intelligence: 75,
          leadership: 85,
          speed: 9,
          troops: 2000,
        ),
        'position': '前锋',
      },
      '许褚': {
        'avatar': '褚',
        'rarity': 3,
        'stats': GeneralStats(
          force: 95,
          intelligence: 40,
          leadership: 70,
          speed: 7,
          troops: 2000,
        ),
        'position': '前锋',
      },
      '曹真': {
        'avatar': '真',
        'rarity': 3,
        'stats': GeneralStats(
          force: 80,
          intelligence: 75,
          leadership: 85,
          speed: 8,
          troops: 2200,
        ),
        'position': '统帅',
      },
      '夏侯惇': {
        'avatar': '惇',
        'rarity': 4,
        'stats': GeneralStats(
          force: 90,
          intelligence: 65,
          leadership: 85,
          speed: 8,
          troops: 2200,
        ),
        'position': '前锋',
      },
      '夏侯渊': {
        'avatar': '渊',
        'rarity': 4,
        'stats': GeneralStats(
          force: 88,
          intelligence: 70,
          leadership: 80,
          speed: 12,
          troops: 2000,
        ),
        'position': '前锋',
      },
      '曹仁': {
        'avatar': '仁',
        'rarity': 4,
        'stats': GeneralStats(
          force: 85,
          intelligence: 70,
          leadership: 88,
          speed: 7,
          troops: 2200,
        ),
        'position': '统帅',
      },
      '于禁': {
        'avatar': '禁',
        'rarity': 3,
        'stats': GeneralStats(
          force: 80,
          intelligence: 70,
          leadership: 85,
          speed: 6,
          troops: 2000,
        ),
        'position': '统帅',
      },
      '庞德': {
        'avatar': '德',
        'rarity': 3,
        'stats': GeneralStats(
          force: 90,
          intelligence: 60,
          leadership: 75,
          speed: 9,
          troops: 1800,
        ),
        'position': '前锋',
      },

      // 东吴集团
      '周瑜': {
        'avatar': '瑜',
        'rarity': 5,
        'stats': GeneralStats(
          force: 75,
          intelligence: 95,
          leadership: 90,
          speed: 8,
          troops: 2500,
        ),
        'position': '统帅',
      },
      '程普': {
        'avatar': '普',
        'rarity': 3,
        'stats': GeneralStats(
          force: 85,
          intelligence: 70,
          leadership: 85,
          speed: 7,
          troops: 2000,
        ),
        'position': '前锋',
      },
      '黄盖': {
        'avatar': '盖',
        'rarity': 3,
        'stats': GeneralStats(
          force: 80,
          intelligence: 75,
          leadership: 80,
          speed: 6,
          troops: 1800,
        ),
        'position': '前锋',
      },
      '吕蒙': {
        'avatar': '蒙',
        'rarity': 4,
        'stats': GeneralStats(
          force: 80,
          intelligence: 88,
          leadership: 85,
          speed: 8,
          troops: 2200,
        ),
        'position': '统帅',
      },
      '陆逊': {
        'avatar': '逊',
        'rarity': 5,
        'stats': GeneralStats(
          force: 70,
          intelligence: 95,
          leadership: 90,
          speed: 8,
          troops: 2500,
        ),
        'position': '统帅',
      },
      '朱然': {
        'avatar': '然',
        'rarity': 3,
        'stats': GeneralStats(
          force: 80,
          intelligence: 75,
          leadership: 80,
          speed: 7,
          troops: 1800,
        ),
        'position': '统帅',
      },
      '朱桓': {
        'avatar': '桓',
        'rarity': 3,
        'stats': GeneralStats(
          force: 85,
          intelligence: 70,
          leadership: 75,
          speed: 8,
          troops: 1800,
        ),
        'position': '前锋',
      },
      '韩当': {
        'avatar': '当',
        'rarity': 3,
        'stats': GeneralStats(
          force: 85,
          intelligence: 65,
          leadership: 80,
          speed: 8,
          troops: 1800,
        ),
        'position': '前锋',
      },
      '孙皓': {
        'avatar': '皓',
        'rarity': 2,
        'stats': GeneralStats(
          force: 60,
          intelligence: 50,
          leadership: 70,
          speed: 5,
          troops: 2000,
        ),
        'position': '统帅',
      },
      '陆抗': {
        'avatar': '抗',
        'rarity': 4,
        'stats': GeneralStats(
          force: 75,
          intelligence: 88,
          leadership: 85,
          speed: 7,
          troops: 2200,
        ),
        'position': '统帅',
      },
      '张悌': {
        'avatar': '悌',
        'rarity': 3,
        'stats': GeneralStats(
          force: 80,
          intelligence: 80,
          leadership: 75,
          speed: 7,
          troops: 1800,
        ),
        'position': '谋士',
      },
      '沈莹': {
        'avatar': '莹',
        'rarity': 2,
        'stats': GeneralStats(
          force: 75,
          intelligence: 70,
          leadership: 70,
          speed: 6,
          troops: 1500,
        ),
        'position': '前锋',
      },
      '诸葛靓': {
        'avatar': '靓',
        'rarity': 3,
        'stats': GeneralStats(
          force: 70,
          intelligence: 85,
          leadership: 75,
          speed: 7,
          troops: 1800,
        ),
        'position': '谋士',
      },
      '岑昏': {
        'avatar': '昏',
        'rarity': 2,
        'stats': GeneralStats(
          force: 65,
          intelligence: 60,
          leadership: 65,
          speed: 6,
          troops: 1500,
        ),
        'position': '前锋',
      },
      '楼玄': {
        'avatar': '玄',
        'rarity': 2,
        'stats': GeneralStats(
          force: 70,
          intelligence: 65,
          leadership: 70,
          speed: 6,
          troops: 1500,
        ),
        'position': '前锋',
      },

      // 蜀汉集团
      '刘璋': {
        'avatar': '璋',
        'rarity': 2,
        'stats': GeneralStats(
          force: 55,
          intelligence: 65,
          leadership: 70,
          speed: 5,
          troops: 2000,
        ),
        'position': '统帅',
      },
      '张任': {
        'avatar': '任',
        'rarity': 3,
        'stats': GeneralStats(
          force: 85,
          intelligence: 70,
          leadership: 80,
          speed: 8,
          troops: 1800,
        ),
        'position': '前锋',
      },
      '严颜': {
        'avatar': '颜',
        'rarity': 3,
        'stats': GeneralStats(
          force: 80,
          intelligence: 75,
          leadership: 85,
          speed: 6,
          troops: 1800,
        ),
        'position': '统帅',
      },
      '刘禅': {
        'avatar': '禅',
        'rarity': 1,
        'stats': GeneralStats(
          force: 40,
          intelligence: 50,
          leadership: 60,
          speed: 4,
          troops: 1500,
        ),
        'position': '统帅',
      },
      '诸葛瞻': {
        'avatar': '瞻',
        'rarity': 3,
        'stats': GeneralStats(
          force: 70,
          intelligence: 80,
          leadership: 75,
          speed: 7,
          troops: 1800,
        ),
        'position': '谋士',
      },
      '张翼': {
        'avatar': '翼',
        'rarity': 3,
        'stats': GeneralStats(
          force: 80,
          intelligence: 70,
          leadership: 75,
          speed: 8,
          troops: 1800,
        ),
        'position': '前锋',
      },

      // 南蛮
      '孟获': {
        'avatar': '获',
        'rarity': 3,
        'stats': GeneralStats(
          force: 90,
          intelligence: 50,
          leadership: 85,
          speed: 6,
          troops: 2500,
        ),
        'position': '统帅',
      },
      '祝融': {
        'avatar': '融',
        'rarity': 3,
        'stats': GeneralStats(
          force: 85,
          intelligence: 70,
          leadership: 75,
          speed: 10,
          troops: 2000,
        ),
        'position': '前锋',
      },
      '兀突骨': {
        'avatar': '骨',
        'rarity': 4,
        'stats': GeneralStats(
          force: 98,
          intelligence: 30,
          leadership: 70,
          speed: 4,
          troops: 3000,
        ),
        'position': '前锋',
      },

      // 司马氏集团
      '司马懿': {
        'avatar': '懿',
        'rarity': 5,
        'stats': GeneralStats(
          force: 70,
          intelligence: 98,
          leadership: 95,
          speed: 7,
          troops: 3000,
        ),
        'position': '统帅',
      },
      '司马师': {
        'avatar': '师',
        'rarity': 4,
        'stats': GeneralStats(
          force: 75,
          intelligence: 90,
          leadership: 88,
          speed: 8,
          troops: 2500,
        ),
        'position': '统帅',
      },
      '司马昭': {
        'avatar': '昭',
        'rarity': 4,
        'stats': GeneralStats(
          force: 75,
          intelligence: 88,
          leadership: 90,
          speed: 8,
          troops: 2500,
        ),
        'position': '统帅',
      },
      '司马炎': {
        'avatar': '炎',
        'rarity': 4,
        'stats': GeneralStats(
          force: 70,
          intelligence: 85,
          leadership: 92,
          speed: 7,
          troops: 3000,
        ),
        'position': '统帅',
      },
      '邓艾': {
        'avatar': '艾',
        'rarity': 4,
        'stats': GeneralStats(
          force: 80,
          intelligence: 88,
          leadership: 85,
          speed: 9,
          troops: 2200,
        ),
        'position': '统帅',
      },
      '钟会': {
        'avatar': '会',
        'rarity': 4,
        'stats': GeneralStats(
          force: 70,
          intelligence: 90,
          leadership: 80,
          speed: 8,
          troops: 2000,
        ),
        'position': '谋士',
      },
      '胡烈': {
        'avatar': '烈',
        'rarity': 2,
        'stats': GeneralStats(
          force: 80,
          intelligence: 60,
          leadership: 70,
          speed: 8,
          troops: 1500,
        ),
        'position': '前锋',
      },
      '郭淮': {
        'avatar': '淮',
        'rarity': 3,
        'stats': GeneralStats(
          force: 75,
          intelligence: 80,
          leadership: 85,
          speed: 7,
          troops: 2000,
        ),
        'position': '统帅',
      },
      '羊祜': {
        'avatar': '祜',
        'rarity': 4,
        'stats': GeneralStats(
          force: 70,
          intelligence: 88,
          leadership: 90,
          speed: 7,
          troops: 2200,
        ),
        'position': '统帅',
      },
      '杜预': {
        'avatar': '预',
        'rarity': 4,
        'stats': GeneralStats(
          force: 65,
          intelligence: 92,
          leadership: 85,
          speed: 7,
          troops: 2000,
        ),
        'position': '谋士',
      },

      // 曹魏后期
      '曹爽': {
        'avatar': '爽',
        'rarity': 3,
        'stats': GeneralStats(
          force: 70,
          intelligence: 70,
          leadership: 75,
          speed: 7,
          troops: 2000,
        ),
        'position': '统帅',
      },
      '何晏': {
        'avatar': '晏',
        'rarity': 2,
        'stats': GeneralStats(
          force: 50,
          intelligence: 80,
          leadership: 65,
          speed: 6,
          troops: 1500,
        ),
        'position': '谋士',
      },
      '丁谧': {
        'avatar': '谧',
        'rarity': 2,
        'stats': GeneralStats(
          force: 55,
          intelligence: 75,
          leadership: 60,
          speed: 6,
          troops: 1500,
        ),
        'position': '谋士',
      },
      '诸葛诞': {
        'avatar': '诞',
        'rarity': 4,
        'stats': GeneralStats(
          force: 80,
          intelligence: 85,
          leadership: 88,
          speed: 8,
          troops: 2200,
        ),
        'position': '统帅',
      },
      '文钦': {
        'avatar': '钦',
        'rarity': 3,
        'stats': GeneralStats(
          force: 85,
          intelligence: 65,
          leadership: 75,
          speed: 9,
          troops: 1800,
        ),
        'position': '前锋',
      },
      '唐咨': {
        'avatar': '咨',
        'rarity': 2,
        'stats': GeneralStats(
          force: 80,
          intelligence: 60,
          leadership: 70,
          speed: 8,
          troops: 1500,
        ),
        'position': '前锋',
      },
    };

    return names.map((name) {
      final data = enemyData[name]!;
      return General(
        id: name.toLowerCase(),
        name: name,
        avatar: data['avatar'],
        rarity: data['rarity'],
        level: 30 + ((data['rarity'] as int) * 5),
        experience: 0,
        maxExperience: 1000,
        stats: data['stats'],
        skills: [
          Skill(
            id: '${name.toLowerCase()}_skill',
            name: '${name}之威',
            description: '发挥${name}的独特战术，对敌军造成伤害',
            type: SkillType.active,
            cooldown: 3,
          ),
        ],
        biography: '三国时期著名将领$name',
        position: data['position'],
      );
    }).toList();
  }

  void _startBattle(BattleStage stage) {
    if (!stage.isUnlocked) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('此关卡尚未解锁')));
      return;
    }

    // 创建自定义战斗，传入敌军数据
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BattleScreen(
          gameState: widget.gameState,
          customEnemies: stage.enemies,
          battleName: stage.name,
          battleDescription: stage.description,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // 战斗胜利，更新关卡状态
        _onBattleVictory(stage);
      }
    });
  }

  Future<void> _onBattleVictory(BattleStage stage) async {
    // 标记关卡完成
    setState(() {
      final stageIndex = _battleStages.indexWhere((s) => s.id == stage.id);
      if (stageIndex != -1) {
        _battleStages[stageIndex] = stage.copyWith(isCompleted: true);

        // 解锁下一关
        if (stageIndex + 1 < _battleStages.length) {
          _battleStages[stageIndex + 1] = _battleStages[stageIndex + 1]
              .copyWith(isUnlocked: true);
        }
      }
    });

    // 检查是否完成了当前章节的所有关卡
    final allStagesCompleted = _battleStages.every((s) => s.isCompleted);
    var updatedGameState = widget.gameState;

    if (allStagesCompleted && widget.gameState.currentChapter < 7) {
      // 解锁下一章节
      updatedGameState = widget.gameState.copyWith(
        currentChapter: widget.gameState.currentChapter + 1,
        currentSection: 1,
      );

      if (mounted) {
        _showChapterCompleteDialog();
      }
    } else {
      // 更新当前章节进度
      updatedGameState = widget.gameState.copyWith(
        currentSection: widget.gameState.currentSection + 1,
      );
    }

    await GameDataService.saveGameState(updatedGameState);

    // 显示奖励
    if (mounted) {
      _showVictoryRewards(stage);
    }
  }

  void _showChapterCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: AppTheme.accentColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('章节完成！'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '恭喜完成第${widget.gameState.currentChapter}章 - ${_getChapterName(widget.gameState.currentChapter)}！',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.gameState.currentChapter < 7) ...[
              const Text('新的篇章即将开启...'),
              const SizedBox(height: 8),
              Text(
                '第${widget.gameState.currentChapter + 1}章 - ${_getChapterName(widget.gameState.currentChapter + 1)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              const Text('你已经完成了所有章节！'),
              const SizedBox(height: 8),
              const Text('感谢你见证了这个波澜壮阔的三国时代！'),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.gameState.currentChapter < 7) {
                // 重新加载新章节
                _loadBattleStages();
              }
            },
            child: const Text('继续征程'),
          ),
        ],
      ),
    );
  }

  void _showVictoryRewards(BattleStage stage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('战斗胜利！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('恭喜通关 ${stage.name}！'),
            const SizedBox(height: 16),
            const Text('获得奖励：'),
            const SizedBox(height: 8),
            Text('• 经验值：${stage.rewards.experience}'),
            Text('• 金币：${stage.rewards.coins}'),
            if (stage.rewards.equipment.isNotEmpty) ...[
              const Text('• 装备：'),
              ...stage.rewards.equipment.map((eq) => Text('  - $eq')),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.secondaryColor,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.accentColor),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
              AppTheme.darkColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 自定义AppBar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppTheme.lightColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '征程',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: AppTheme.accentColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // 章节选择按钮
                    PopupMenuButton<int>(
                      icon: const Icon(
                        Icons.menu_book,
                        color: AppTheme.lightColor,
                      ),
                      onSelected: (chapter) {
                        if (chapter <= _getMaxUnlockedChapter()) {
                          _switchToChapter(chapter);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('此章节尚未解锁')),
                          );
                        }
                      },
                      itemBuilder: (context) => List.generate(7, (index) {
                        final chapter = index + 1;
                        final isUnlocked = chapter <= _getMaxUnlockedChapter();
                        return PopupMenuItem<int>(
                          value: chapter,
                          enabled: isUnlocked,
                          child: Row(
                            children: [
                              Icon(
                                isUnlocked ? Icons.book : Icons.lock,
                                size: 16,
                                color: isUnlocked
                                    ? AppTheme.accentColor
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '第${chapter}章 ${_getChapterName(chapter)}',
                                style: TextStyle(
                                  color: isUnlocked
                                      ? AppTheme.lightColor
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 章节信息
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              30 * (1 - _progressAnimation.value),
                            ),
                            child: Opacity(
                              opacity: _progressAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.cardColor.withOpacity(0.9),
                                      AppTheme.cardColor.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme.accentColor.withOpacity(
                                      0.3,
                                    ),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.accentColor.withOpacity(
                                        0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '第${widget.gameState.currentChapter}章 - ${_getChapterName(widget.gameState.currentChapter)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '进度：${_getCompletedStages()}/${_battleStages.length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppTheme.accentColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppTheme.accentColor
                                                .withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.sports_martial_arts,
                                            color: AppTheme.accentColor,
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // 进度条
                                    Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: _battleStages.isEmpty
                                            ? 0
                                            : _getCompletedStages() /
                                                  _battleStages.length,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppTheme.accentColor,
                                                Color(0xFFffd700),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // 章节故事
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.8),
                              AppTheme.primaryColor.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentColor.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.auto_stories,
                                    color: AppTheme.accentColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '章节背景',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.accentColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getChapterStory(
                                  widget.gameState.currentChapter,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      height: 1.6,
                                      fontSize: 14,
                                      color: AppTheme.lightColor.withOpacity(
                                        0.9,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 关卡列表
                      Expanded(
                        child: ListView.builder(
                          itemCount: _battleStages.length,
                          itemBuilder: (context, index) {
                            final stage = _battleStages[index];
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 400 + (index * 100),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOutQuart,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(50 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _buildStageCard(stage, index),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageCard(BattleStage stage, int index) {
    final isCurrentStage = index == _currentStageIndex;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: stage.isCompleted
              ? [Colors.green.withOpacity(0.2), Colors.green.withOpacity(0.1)]
              : stage.isUnlocked
              ? [
                  AppTheme.cardColor.withOpacity(0.9),
                  AppTheme.cardColor.withOpacity(0.7),
                ]
              : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: stage.isCompleted
              ? Colors.green.withOpacity(0.5)
              : stage.isUnlocked
              ? AppTheme.accentColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: stage.isCompleted
                ? Colors.green.withOpacity(0.2)
                : stage.isUnlocked
                ? AppTheme.accentColor.withOpacity(0.1)
                : Colors.transparent,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: stage.isUnlocked ? () => _startBattle(stage) : null,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 关卡标题
                Row(
                  children: [
                    // 关卡状态图标
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: stage.isCompleted
                              ? [Colors.green, Colors.green.shade700]
                              : stage.isUnlocked
                              ? [AppTheme.accentColor, const Color(0xFFb8941f)]
                              : [Colors.grey, Colors.grey.shade700],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (stage.isCompleted
                                        ? Colors.green
                                        : stage.isUnlocked
                                        ? AppTheme.accentColor
                                        : Colors.grey)
                                    .withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getStageStatusIcon(stage),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // 关卡信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  stage.name,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: stage.isUnlocked
                                            ? AppTheme.lightColor
                                            : AppTheme.lightColor.withOpacity(
                                                0.5,
                                              ),
                                      ),
                                ),
                              ),
                              if (isCurrentStage)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppTheme.accentColor,
                                        Color(0xFFffd700),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    '当前',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '难度：',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppTheme.lightColor.withOpacity(
                                        0.8,
                                      ),
                                    ),
                              ),
                              const SizedBox(width: 4),
                              ...List.generate(
                                5,
                                (i) => Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Icon(
                                    Icons.star,
                                    size: 14,
                                    color: i < stage.difficulty
                                        ? AppTheme.accentColor
                                        : AppTheme.lightColor.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 奖励预览
                    if (stage.isUnlocked && !stage.isCompleted)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.card_giftcard,
                              color: AppTheme.accentColor,
                              size: 18,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${stage.rewards.coins}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppTheme.accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // 关卡描述
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    stage.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: stage.isUnlocked
                          ? AppTheme.lightColor
                          : AppTheme.lightColor.withOpacity(0.5),
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 敌军预览
                if (stage.isUnlocked) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.shield,
                        size: 16,
                        color: Colors.red.withOpacity(0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '敌军：',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: stage.enemies
                          .map(
                            (enemy) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.withOpacity(0.8),
                                      Colors.red.shade800,
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.red.withOpacity(0.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    enemy.avatar,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                const SizedBox(height: 16),

                // 行动按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: stage.isUnlocked
                        ? () => _startBattle(stage)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: stage.isCompleted
                              ? [Colors.green, Colors.green.shade700]
                              : stage.isUnlocked
                              ? [AppTheme.accentColor, const Color(0xFFb8941f)]
                              : [Colors.grey, Colors.grey.shade700],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              stage.isCompleted
                                  ? Icons.check_circle
                                  : stage.isUnlocked
                                  ? Icons.play_arrow
                                  : Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              stage.isCompleted
                                  ? '已完成'
                                  : (stage.isUnlocked ? '开始战斗' : '未解锁'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getStageStatusIcon(BattleStage stage) {
    if (stage.isCompleted) return Icons.check;
    if (stage.isUnlocked) return Icons.sports_martial_arts;
    return Icons.lock;
  }

  int _getCompletedStages() {
    return _battleStages.where((stage) => stage.isCompleted).length;
  }

  String _getChapterName(int chapter) {
    switch (chapter) {
      case 1:
        return '乱世初起';
      case 2:
        return '群雄争霸';
      case 3:
        return '三足鼎立';
      case 4:
        return '汉中争夺';
      case 5:
        return '蜀汉兴衰';
      case 6:
        return '司马当道';
      case 7:
        return '天下归晋';
      default:
        return '未知篇章';
    }
  }

  String _getChapterStory(int chapter) {
    switch (chapter) {
      case 1:
        return '东汉末年，宦官专权，民不聊生。张角以太平道聚众，黄巾起义席卷天下。朝廷震动，各地豪强纷纷起兵。你作为一名有志之士，在这乱世中踏上了征程。董卓入京，废立皇帝，天下诸侯共起讨之。虎牢关前，吕布独战群雄，威震天下。乱世已起，英雄辈出，你将如何在这波澜壮阔的时代中书写自己的传奇？';
      case 2:
        return '董卓已死，天下大乱。各路诸侯割据一方，互相征伐。北方袁绍势力最强，拥兵十万，意图统一天下。曹操挟天子以令诸侯，与袁绍在官渡展开决战。这场战役将决定北方的统治者，也将影响整个天下的格局。颜良文丑虽勇，但难敌关羽神威。官渡一战，奠定了曹操统一北方的基础。';
      case 3:
        return '曹操统一北方后，挥师南下，意图一统天下。然而在赤壁，遇到了孙刘联军的顽强抵抗。周瑜火攻，诸葛亮借东风，一场大火烧出了三分天下的格局。曹操败走华容道，关羽念旧情而放行。从此，魏蜀吴三国鼎立，开始了长达数十年的争霸。刘备入川，孙权据江东，曹操守中原，三足鼎立的时代正式开始。';
      case 4:
        return '三国鼎立后，各国都在寻求扩张的机会。汉中是连接关中与巴蜀的要地，战略地位极其重要。刘备为了北伐中原，必须先夺取汉中。定军山一战，黄忠刀劈夏侯渊，蜀军士气大振。然而关羽北伐襄樊，虽然水淹七军，威震华夏，但最终败走麦城，一代武圣就此陨落。关羽之死，不仅是蜀汉的重大损失，也改变了整个三国的格局。';
      case 5:
        return '关羽死后，刘备悲愤交加，不顾群臣劝阻，倾国之兵伐吴。然而在夷陵，遇到了陆逊的火攻，蜀军大败，刘备病死白帝城。诸葛亮受托孤之重，辅佐后主刘禅。为了稳定后方，诸葛亮南征孟获，七擒七纵，以德服人。随后开始了六出祁山的北伐，但最终壮志未酬，病逝五丈原。诸葛亮死后，蜀汉逐渐衰落，再也无力与魏国抗衡。';
      case 6:
        return '诸葛亮死后，司马懿在魏国的地位日益重要。高平陵之变，司马懿诛杀曹爽集团，司马氏开始掌控魏国政权。司马师、司马昭相继执政，平定淮南三叛，巩固了司马氏的统治。邓艾偷渡阴平，直取成都，蜀汉灭亡。姜维虽然据守剑阁，但已无力回天。刘禅开城投降，四十三年的蜀汉政权就此终结。司马氏距离统一天下，只剩下最后一步。';
      case 7:
        return '蜀汉灭亡后，司马炎废魏立晋，建立西晋王朝。此时天下只剩下东吴一国，统一指日可待。司马炎决心完成统一大业，派遣大军水陆并进，攻打东吴。王濬楼船下益州，晋军势如破竹。孙皓昏庸无能，东吴内部矛盾重重，难以抵抗晋军的攻势。石头城陷落，建业投降，东吴灭亡。至此，历时九十年的三国时代正式结束，天下重归一统。你见证了这个波澜壮阔的时代，也在历史的长河中留下了自己的足迹。';
      default:
        return '未知的篇章等待着你去书写...';
    }
  }

  int _getMaxUnlockedChapter() {
    // 玩家可以访问当前章节和之前完成的章节
    // 简化逻辑：如果当前章节 > 1，说明前面的章节都已完成
    return widget.gameState.currentChapter;
  }

  void _switchToChapter(int chapter) {
    if (chapter != widget.gameState.currentChapter) {
      // 创建临时的游戏状态来显示指定章节
      final tempGameState = widget.gameState.copyWith(
        currentChapter: chapter,
        currentSection: 1,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JourneyScreen(gameState: tempGameState),
        ),
      );
    }
  }
}

class BattleStage {
  final String id;
  final String name;
  final String description;
  final int difficulty; // 1-5星难度
  final List<General> enemies;
  final BattleRewards rewards;
  final bool isCompleted;
  final bool isUnlocked;

  BattleStage({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.enemies,
    required this.rewards,
    this.isCompleted = false,
    this.isUnlocked = false,
  });

  BattleStage copyWith({
    String? id,
    String? name,
    String? description,
    int? difficulty,
    List<General>? enemies,
    BattleRewards? rewards,
    bool? isCompleted,
    bool? isUnlocked,
  }) {
    return BattleStage(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      enemies: enemies ?? this.enemies,
      rewards: rewards ?? this.rewards,
      isCompleted: isCompleted ?? this.isCompleted,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

class BattleRewards {
  final int experience;
  final int coins;
  final List<String> equipment;

  BattleRewards({
    required this.experience,
    required this.coins,
    this.equipment = const [],
  });
}
