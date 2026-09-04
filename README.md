# 日常集 · 生活工作台

> 一体式生活记录 App：记账理财 / 习惯健康 / 减脂健身 / 日程统筹 / 待买清单 / 书影音收藏。
> 纯本地优先、离线可用、包体小、启动快，架构预留云端同步。

<p align="center">
  <a href="https://polyformproject.org/licenses/noncommercial/1.0.0/"><img src="https://img.shields.io/badge/license-PolyForm%20Noncommercial%201.0.0-0000FF.svg" alt="PolyForm Noncommercial 1.0.0"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white" alt="Flutter 3.44"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white" alt="Dart 3.12"></a>
  <a href="https://www.android.com/"><img src="https://img.shields.io/badge/-Android-3DDC84?logo=android&logoColor=white" alt="Android"></a>
  <a href="https://www.apple.com/ios/"><img src="https://img.shields.io/badge/-iOS-000000?logo=apple&logoColor=white" alt="iOS"></a>
  <a href="https://github.com/DHJ999/life_daily_workspace/releases"><img src="https://img.shields.io/github/v/release/DHJ999/life_daily_workspace" alt="GitHub Release"></a>
  <a href="https://github.com/DHJ999/life_daily_workspace"><img src="https://img.shields.io/github/stars/DHJ999/life_daily_workspace" alt="GitHub Stars"></a>
  <a href="https://github.com/DHJ999/life_daily_workspace/commits/main"><img src="https://img.shields.io/github/last-commit/DHJ999/life_daily_workspace" alt="Last Commit"></a>
</p>

🌐 **多语言**：中文 | [English](./README.en.md)

---

## 🧭 这是什么

「日常集」把日常生活里最常见的六类记录收进一个 App，避免装一堆各自为政的小工具。
打开即用、随手就记，界面克制干净，图表全部手绘实现，不依赖任何第三方图表库。

**当前版本：v1.0.1（versionCode 2）** · 平台：Android（iOS 代码同库，待接 macOS 构建环境）

## 📦 功能模块

| 模块 | 功能 |
|------|------|
| **📌 今日概览** | 「今天要处理」置顶区：逾期标红、到期提醒，昨日未完成自动顺延 |
| **💰 记账理财** | 收支记录、分类管理、月度切换、分类筛选、消费结构饼图（CustomPaint 手绘） |
| **✅ 习惯健康** | 自定义习惯增删，支持勾选 / 计数 / 数值三种打卡方式，30 天打卡热力图、连续天数 |
| **⚖️ 减脂健身** | 体重 / 体脂记录、折线图 + 7 日均线、BMI、目标进度 |
| **🗓️ 日程统筹** | 日程项管理，按日期组织，状态流转 |
| **🛒 待买清单** | 物品、数量、预估价格、已买标记 |
| **🎬 书影音收藏** | 图书 / 影视 / 音乐分类，状态跟踪、星级评分、短评、封面墙与列表双视图 |

## 🛠️ 技术栈

- **Flutter 3.44**（Dart 3.12），一套代码跑 Android + iOS
- **状态管理**：Flutter 内置 `ChangeNotifier` + `InheritedWidget`，零第三方状态库（减小包体、降低维护成本）
- **本地存储**：`shared_preferences`（KV 持久化，key 前缀 `wb_`）
- **图表**：纯 `CustomPaint` 手绘（饼图 / 折线图 / 热力图），无外部图表库
- **国际化**：官方 gen_l10n（`flutter_localizations` + ARB），首页右上角设置里可一键切换 **简体中文 / English**，选择即时生效并持久化
- **依赖**：`shared_preferences` + `intl` + SDK 自带 `flutter_localizations`，极简依赖面

## 🗂️ 项目结构

```
lib/
├── main.dart                 # 入口：LocalStore → LocalRepository → AppState
├── theme.dart                # 全局主题（暖米白底 + 墨绿主色）
├── models/                   # 六模块数据模型（纯 Dart，手写 toJson/fromJson）
│   ├── money_record.dart     # 记账
│   ├── habit.dart            # 习惯（iconCodePoint + const 图标表，保证 tree-shake）
│   ├── fitness_record.dart   # 减脂
│   ├── plan_item.dart        # 日程
│   ├── shopping_item.dart    # 待买
│   └── media_item.dart       # 书影音
├── data/
│   └── local_store.dart      # 本地 KV 存储封装
├── repository/               # ★ 数据访问抽象层
│   ├── data_repository.dart  # 抽象接口
│   └── local_repository.dart # 本地实现
├── state/
│   └── app_state.dart        # 全局状态 + locale + 各模块数据增删改
├── l10n/                     # 国际化
│   ├── app_zh.arb            # 简体中文文案源（template）
│   ├── app_en.arb            # English 文案源
│   ├── data_labels.dart      # 数据标签双语映射（分类/类型显示层翻译，不改存储值）
│   └── generated/            # gen_l10n 生成的 AppLocalizations（随仓库提交）
├── screens/                  # 七屏（今日概览 + 六模块）
└── widgets/
    └── common.dart           # SoftCard / SectionTitle / EmptyState / fmtMoney
```

## 🏗️ 架构要点

- **Repository 抽象层**：业务代码只依赖 `DataRepository` 接口，不关心数据在本地还是云端。
  当前实现为 `LocalRepository`；将来接云端同步只需新增 `CloudRepository` 实现同一接口，
  业务代码零改动即可切换。
- **数据模型与网页版对齐**：JSON 字段结构与 WorkBuddy 资料库在线版一致，为将来打通网页端数据铺路。
- **图标字体 tree-shake**：模型存 `int iconCodePoint`（而非运行时 `IconData`），MaterialIcons
  从 1.6MB 压到 8KB（99.5%）。

## 🔨 构建与打包

```bash
# 国内镜像（推荐，写入 shell 或环境变量）
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
# Gradle 缓存目录：Windows 下必须写带盘符的绝对路径
# 写成 /d/.gradle 会被解析成「当前盘符 + /d/.gradle」，
# 在 E 盘的项目里执行时实际生成的是 E:\d\.gradle，而不是 D 盘的缓存目录。
export GRADLE_USER_HOME="D:/.gradle"
export ANDROID_HOME="D:/Android/Sdk"
export JAVA_HOME="D:/Android/Android Studio/jbr"

# 运行到真机 / 模拟器
flutter run

# Debug 包（仅调试用，体积大）
flutter build apk --debug

# Release 通用包（正式签名）
flutter build apk --release

# Release 分包（各 CPU 架构独立，体积更小）
flutter build apk --release --split-per-abi

# iOS（需 macOS + Xcode）
flutter build ios
```

**产物位置**：`build/app/outputs/flutter-apk/`

### 🔑 正式签名（重要）

- release 包使用正式签名构建（`android/app/build.gradle.kts` 中 `signingConfigs.release` 已启用）。
- 密钥库与密码配置文件的**完整说明见本机文件 `android/SIGNING-INFO.local.md`**（该文件不入库、不随仓库分发，仅机主本机保留）。
- 密钥相关文件（`.jks` / `key.properties` 等）均已加入 `.gitignore`，不会进入版本库。

> ⚠️ **请务必备份密钥库文件（见上述本地备忘）。**
> 密钥库一旦丢失，将无法为已发布的 App 提供后续更新（签名不一致无法覆盖安装）。

### 📜 历史产物

- v1.0.0 通用包：`日常集生活工作台_v1.0.0.apk`（约 48MB，已复制到桌面）
- v1.0.0 分包：arm64-v8a 17.0MB / armeabi-v7a 14.5MB / x86_64 18.4MB

## 🧪 测试

```bash
flutter test test/models_test.dart   # 数据模型 JSON 序列化往返测试
flutter analyze                      # 静态分析（当前无 error/warning）
```

## 🔒 数据与隐私

- 数据 100% 存于手机本地（`shared_preferences`），不上传任何服务器，离线完全可用。
- 换机迁移：暂通过重装 + 手工录入；云端同步接入后可自动迁移。

## 🗺️ 路线图

1. **云端同步**：新增 `CloudRepository` 对接资料库在线数据表，多设备同步
2. **iOS 构建**：接入 macOS 构建环境，出 TestFlight 包
3. **数据导出**：全量数据导出 JSON 备份 / 恢复
4. **桌面小组件**：记账快捷入口、习惯打卡桌面插件

## 📄 许可协议

本项目采用 **PolyForm Noncommercial License 1.0.0**（源码可得许可，非 OSI 开源协议；全文见 [LICENSE](LICENSE)，官方文本见 [polyformproject.org](https://polyformproject.org/licenses/noncommercial/1.0.0/)）：允许任何**非商业**目的的使用、修改与再分发；商业用途需另行取得授权。Copyright © 2026 DHJ999。

