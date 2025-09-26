# 角色图片资源配置

## 可用角色图片资源

游戏中只包含以下有图片资源的角色：

### 图片文件列表
```
assets/role/Role_1.png  # 赵云
assets/role/Role_2.png  # 吕布
assets/role/Role_3.png  # 司马懿
assets/role/Role_4.png  # 貂蝉
assets/role/Role_5.png  # 华佗
assets/role/Role_6.png  # 姜维
assets/role/Role_7.png  # 孙策
assets/role/Role_8.png  # 孙尚香
assets/role/Role_9.png  # 许褚
assets/role/Role_10.png # 张春华
assets/role/Role_11.png # 张角
assets/role/Role_12.png # 赵飞燕
assets/role/Role_13.png # 小兵
```

## 游戏中的角色配置

### 默认武将列表
所有游戏中出现的武将都已更新为有图片资源的角色：

1. **赵云** - 常胜将军 (Role_1.png)
2. **吕布** - 飞将 (Role_2.png)
3. **司马懿** - 冢虎 (Role_3.png)
4. **貂蝉** - 绝世美人 (Role_4.png)
5. **华佗** - 神医 (Role_5.png)
6. **姜维** - 蜀汉大将军 (Role_6.png)
7. **孙策** - 小霸王 (Role_7.png)
8. **孙尚香** - 弓腰姬 (Role_8.png)
9. **许褚** - 虎痴 (Role_9.png)
10. **张春华** - 宣穆皇后 (Role_10.png)
11. **张角** - 太平道主 (Role_11.png)
12. **赵飞燕** - 汉成帝皇后 (Role_12.png)
13. **小兵** - 普通士兵 (Role_13.png)

### 默认阵型配置
默认阵型已更新为使用有图片的角色：
- 前排左：吕布
- 前排中：赵云
- 前排右：孙策
- 中排中：司马懿
- 后排中：华佗

### 图片加载机制
- 阵型界面使用 `AssetImage(general.imagePath)` 加载角色图片
- 包含错误处理机制，图片加载失败时有容错处理
- 支持圆形裁剪和渐变遮罩效果

## 移除的角色
以下角色因为没有图片资源已从游戏中移除：
- 刘备
- 关羽
- 张飞
- 诸葛亮
- 曹操

## 关卡敌人更新
部分关卡的敌人也已更新为使用有图片的角色作为BOSS：
- 第一次北伐：张角、司马懿、郭淮
- 蜀汉灭亡：姜维、张春华、张角

## 注意事项
1. 所有角色名称必须与图片文件名完全匹配（不包含.png扩展名）
2. 新增角色时必须先确保有对应的图片资源
3. 图片格式统一为PNG格式
4. 建议图片尺寸为正方形，以适配圆形显示