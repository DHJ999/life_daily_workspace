import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'日常集'**
  String get appName;

  /// No description provided for @appNameFull.
  ///
  /// In zh, this message translates to:
  /// **'日常集 · 生活工作台'**
  String get appNameFull;

  /// No description provided for @navToday.
  ///
  /// In zh, this message translates to:
  /// **'今日'**
  String get navToday;

  /// No description provided for @navMoney.
  ///
  /// In zh, this message translates to:
  /// **'记账'**
  String get navMoney;

  /// No description provided for @navHabits.
  ///
  /// In zh, this message translates to:
  /// **'习惯'**
  String get navHabits;

  /// No description provided for @navFitness.
  ///
  /// In zh, this message translates to:
  /// **'减脂'**
  String get navFitness;

  /// No description provided for @navPlan.
  ///
  /// In zh, this message translates to:
  /// **'日程'**
  String get navPlan;

  /// No description provided for @navShopping.
  ///
  /// In zh, this message translates to:
  /// **'待买'**
  String get navShopping;

  /// No description provided for @navMedia.
  ///
  /// In zh, this message translates to:
  /// **'书影音'**
  String get navMedia;

  /// No description provided for @commonSave.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// No description provided for @commonAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get commonAll;

  /// No description provided for @commonNote.
  ///
  /// In zh, this message translates to:
  /// **'备注（可选）'**
  String get commonNote;

  /// No description provided for @dashToday.
  ///
  /// In zh, this message translates to:
  /// **'今天要处理'**
  String get dashToday;

  /// No description provided for @dashStatExpense.
  ///
  /// In zh, this message translates to:
  /// **'今日支出'**
  String get dashStatExpense;

  /// No description provided for @dashStatIncome.
  ///
  /// In zh, this message translates to:
  /// **'今日收入'**
  String get dashStatIncome;

  /// No description provided for @dashStatHabit.
  ///
  /// In zh, this message translates to:
  /// **'习惯完成'**
  String get dashStatHabit;

  /// No description provided for @dashQuick.
  ///
  /// In zh, this message translates to:
  /// **'快捷入口'**
  String get dashQuick;

  /// No description provided for @dashAllDone.
  ///
  /// In zh, this message translates to:
  /// **'今天的事都处理完了，可以歇一歇'**
  String get dashAllDone;

  /// No description provided for @dashTodoCountFmt.
  ///
  /// In zh, this message translates to:
  /// **'{count} 件'**
  String dashTodoCountFmt(int count);

  /// No description provided for @dashOverdueFmt.
  ///
  /// In zh, this message translates to:
  /// **'逾期：{title}'**
  String dashOverdueFmt(String title);

  /// No description provided for @dashTodayItemFmt.
  ///
  /// In zh, this message translates to:
  /// **'今日：{title}'**
  String dashTodayItemFmt(String title);

  /// No description provided for @dashToBuyFmt.
  ///
  /// In zh, this message translates to:
  /// **'待买：{name} ×{qty}'**
  String dashToBuyFmt(String name, int qty);

  /// No description provided for @dashModMoneyFmt.
  ///
  /// In zh, this message translates to:
  /// **'{count} 条'**
  String dashModMoneyFmt(int count);

  /// No description provided for @dashModHabitFmt.
  ///
  /// In zh, this message translates to:
  /// **'{count} 个习惯'**
  String dashModHabitFmt(int count);

  /// No description provided for @dashModFitnessFmt.
  ///
  /// In zh, this message translates to:
  /// **'{count} 条记录'**
  String dashModFitnessFmt(int count);

  /// No description provided for @dashModPlanFmt.
  ///
  /// In zh, this message translates to:
  /// **'{count} 件事'**
  String dashModPlanFmt(int count);

  /// No description provided for @dashModShoppingFmt.
  ///
  /// In zh, this message translates to:
  /// **'{count} 件待买'**
  String dashModShoppingFmt(int count);

  /// No description provided for @dashModMediaFmt.
  ///
  /// In zh, this message translates to:
  /// **'{count} 部'**
  String dashModMediaFmt(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get settingsLanguage;

  /// No description provided for @settingsStorage.
  ///
  /// In zh, this message translates to:
  /// **'数据存储'**
  String get settingsStorage;

  /// No description provided for @settingsStorageSub.
  ///
  /// In zh, this message translates to:
  /// **'当前：本地存储'**
  String get settingsStorageSub;

  /// No description provided for @settingsAbout.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get settingsAbout;

  /// No description provided for @settingsLanguageSub.
  ///
  /// In zh, this message translates to:
  /// **'界面显示语言，简体中文或英文'**
  String get settingsLanguageSub;

  /// No description provided for @moneyTitle.
  ///
  /// In zh, this message translates to:
  /// **'记账理财'**
  String get moneyTitle;

  /// No description provided for @moneyMonthExpense.
  ///
  /// In zh, this message translates to:
  /// **'本月支出'**
  String get moneyMonthExpense;

  /// No description provided for @moneyMonthIncome.
  ///
  /// In zh, this message translates to:
  /// **'本月收入'**
  String get moneyMonthIncome;

  /// No description provided for @moneyBalance.
  ///
  /// In zh, this message translates to:
  /// **'结余'**
  String get moneyBalance;

  /// No description provided for @moneyEmptyMonth.
  ///
  /// In zh, this message translates to:
  /// **'本月还没有记录'**
  String get moneyEmptyMonth;

  /// No description provided for @moneyEmptyMonthHint.
  ///
  /// In zh, this message translates to:
  /// **'点右上角 + 记一笔'**
  String get moneyEmptyMonthHint;

  /// No description provided for @moneyEmptyCat.
  ///
  /// In zh, this message translates to:
  /// **'该分类暂无记录'**
  String get moneyEmptyCat;

  /// No description provided for @moneyAddTitle.
  ///
  /// In zh, this message translates to:
  /// **'记一笔'**
  String get moneyAddTitle;

  /// No description provided for @moneyExpense.
  ///
  /// In zh, this message translates to:
  /// **'支出'**
  String get moneyExpense;

  /// No description provided for @moneyIncome.
  ///
  /// In zh, this message translates to:
  /// **'收入'**
  String get moneyIncome;

  /// No description provided for @moneyAmount.
  ///
  /// In zh, this message translates to:
  /// **'金额'**
  String get moneyAmount;

  /// No description provided for @moneyPieTitle.
  ///
  /// In zh, this message translates to:
  /// **'消费结构'**
  String get moneyPieTitle;

  /// No description provided for @habitsTitle.
  ///
  /// In zh, this message translates to:
  /// **'习惯健康'**
  String get habitsTitle;

  /// No description provided for @habitsEmpty.
  ///
  /// In zh, this message translates to:
  /// **'还没有习惯'**
  String get habitsEmpty;

  /// No description provided for @habitsEmptyHint.
  ///
  /// In zh, this message translates to:
  /// **'点右上角 + 新建一个习惯'**
  String get habitsEmptyHint;

  /// No description provided for @habitsMy.
  ///
  /// In zh, this message translates to:
  /// **'我的习惯'**
  String get habitsMy;

  /// No description provided for @habitsHeat.
  ///
  /// In zh, this message translates to:
  /// **'30 天热力图'**
  String get habitsHeat;

  /// No description provided for @habitsAddTitle.
  ///
  /// In zh, this message translates to:
  /// **'新建习惯'**
  String get habitsAddTitle;

  /// No description provided for @habitsName.
  ///
  /// In zh, this message translates to:
  /// **'习惯名称'**
  String get habitsName;

  /// No description provided for @habitsNameHint.
  ///
  /// In zh, this message translates to:
  /// **'如：早起、喝水、跑步'**
  String get habitsNameHint;

  /// No description provided for @habitsTypeLabel.
  ///
  /// In zh, this message translates to:
  /// **'打卡方式'**
  String get habitsTypeLabel;

  /// No description provided for @habitsChipCheck.
  ///
  /// In zh, this message translates to:
  /// **'勾选'**
  String get habitsChipCheck;

  /// No description provided for @habitsChipCounter.
  ///
  /// In zh, this message translates to:
  /// **'计数'**
  String get habitsChipCounter;

  /// No description provided for @habitsChipValue.
  ///
  /// In zh, this message translates to:
  /// **'数值'**
  String get habitsChipValue;

  /// No description provided for @habitsTarget.
  ///
  /// In zh, this message translates to:
  /// **'目标'**
  String get habitsTarget;

  /// No description provided for @habitsUnit.
  ///
  /// In zh, this message translates to:
  /// **'单位（可选）'**
  String get habitsUnit;

  /// No description provided for @habitsCreate.
  ///
  /// In zh, this message translates to:
  /// **'创建'**
  String get habitsCreate;

  /// No description provided for @habitsDoneStatus.
  ///
  /// In zh, this message translates to:
  /// **'完成/未完成'**
  String get habitsDoneStatus;

  /// No description provided for @habitsTargetFmt.
  ///
  /// In zh, this message translates to:
  /// **'目标 {target}'**
  String habitsTargetFmt(String target);

  /// No description provided for @habitsStreakFmt.
  ///
  /// In zh, this message translates to:
  /// **'连续 {days} 天'**
  String habitsStreakFmt(int days);

  /// No description provided for @heatLow.
  ///
  /// In zh, this message translates to:
  /// **'少'**
  String get heatLow;

  /// No description provided for @heatHigh.
  ///
  /// In zh, this message translates to:
  /// **'多'**
  String get heatHigh;

  /// No description provided for @heatLast30.
  ///
  /// In zh, this message translates to:
  /// **'近 30 天'**
  String get heatLast30;

  /// No description provided for @heatTooltipFmt.
  ///
  /// In zh, this message translates to:
  /// **'{date} {pct}%'**
  String heatTooltipFmt(String date, String pct);

  /// No description provided for @fitnessTitle.
  ///
  /// In zh, this message translates to:
  /// **'减脂健身'**
  String get fitnessTitle;

  /// No description provided for @fitnessTrend.
  ///
  /// In zh, this message translates to:
  /// **'体重趋势（含 7 日均线）'**
  String get fitnessTrend;

  /// No description provided for @fitnessTrendHint.
  ///
  /// In zh, this message translates to:
  /// **'至少录入 2 条体重记录后显示趋势'**
  String get fitnessTrendHint;

  /// No description provided for @fitnessAddTitle.
  ///
  /// In zh, this message translates to:
  /// **'记录体重体脂'**
  String get fitnessAddTitle;

  /// No description provided for @fitnessWeight.
  ///
  /// In zh, this message translates to:
  /// **'体重（kg）'**
  String get fitnessWeight;

  /// No description provided for @fitnessBodyFat.
  ///
  /// In zh, this message translates to:
  /// **'体脂率（%）'**
  String get fitnessBodyFat;

  /// No description provided for @fitnessGoalTitle.
  ///
  /// In zh, this message translates to:
  /// **'目标设置'**
  String get fitnessGoalTitle;

  /// No description provided for @fitnessGoalWeight.
  ///
  /// In zh, this message translates to:
  /// **'目标体重（kg）'**
  String get fitnessGoalWeight;

  /// No description provided for @fitnessHeight.
  ///
  /// In zh, this message translates to:
  /// **'身高（cm，用于 BMI）'**
  String get fitnessHeight;

  /// No description provided for @fitnessCalorie.
  ///
  /// In zh, this message translates to:
  /// **'每日热量目标（kcal）'**
  String get fitnessCalorie;

  /// No description provided for @fitnessCurWeight.
  ///
  /// In zh, this message translates to:
  /// **'当前体重'**
  String get fitnessCurWeight;

  /// No description provided for @fitnessBmi.
  ///
  /// In zh, this message translates to:
  /// **'BMI'**
  String get fitnessBmi;

  /// No description provided for @fitnessGoalWeightShort.
  ///
  /// In zh, this message translates to:
  /// **'目标体重'**
  String get fitnessGoalWeightShort;

  /// No description provided for @bmiThin.
  ///
  /// In zh, this message translates to:
  /// **'偏瘦'**
  String get bmiThin;

  /// No description provided for @bmiNormal.
  ///
  /// In zh, this message translates to:
  /// **'正常'**
  String get bmiNormal;

  /// No description provided for @bmiOver.
  ///
  /// In zh, this message translates to:
  /// **'偏胖'**
  String get bmiOver;

  /// No description provided for @bmiObese.
  ///
  /// In zh, this message translates to:
  /// **'肥胖'**
  String get bmiObese;

  /// No description provided for @fitnessProgressFmt.
  ///
  /// In zh, this message translates to:
  /// **'已达成 {pct}%'**
  String fitnessProgressFmt(int pct);

  /// No description provided for @fitnessCalorieGoalFmt.
  ///
  /// In zh, this message translates to:
  /// **'热量目标 {kcal} kcal/日'**
  String fitnessCalorieGoalFmt(int kcal);

  /// No description provided for @fitnessFatFmt.
  ///
  /// In zh, this message translates to:
  /// **'体脂 {fat}%'**
  String fitnessFatFmt(String fat);

  /// No description provided for @planTitle.
  ///
  /// In zh, this message translates to:
  /// **'日程统筹'**
  String get planTitle;

  /// No description provided for @planEmpty.
  ///
  /// In zh, this message translates to:
  /// **'这一天还没有日程'**
  String get planEmpty;

  /// No description provided for @planAddTitle.
  ///
  /// In zh, this message translates to:
  /// **'新增日程'**
  String get planAddTitle;

  /// No description provided for @planItemField.
  ///
  /// In zh, this message translates to:
  /// **'事项'**
  String get planItemField;

  /// No description provided for @planDate.
  ///
  /// In zh, this message translates to:
  /// **'日期'**
  String get planDate;

  /// No description provided for @planType.
  ///
  /// In zh, this message translates to:
  /// **'类型'**
  String get planType;

  /// No description provided for @shopTitle.
  ///
  /// In zh, this message translates to:
  /// **'待买清单'**
  String get shopTitle;

  /// No description provided for @shopTotal.
  ///
  /// In zh, this message translates to:
  /// **'待买合计'**
  String get shopTotal;

  /// No description provided for @shopShowBought.
  ///
  /// In zh, this message translates to:
  /// **'显示已买'**
  String get shopShowBought;

  /// No description provided for @shopEmptyTodo.
  ///
  /// In zh, this message translates to:
  /// **'待买清单是空的'**
  String get shopEmptyTodo;

  /// No description provided for @shopEmptyBought.
  ///
  /// In zh, this message translates to:
  /// **'还没有已买记录'**
  String get shopEmptyBought;

  /// No description provided for @shopEmptyHint.
  ///
  /// In zh, this message translates to:
  /// **'点右上角 + 加一件'**
  String get shopEmptyHint;

  /// No description provided for @shopQtyFmt.
  ///
  /// In zh, this message translates to:
  /// **'{count} 件'**
  String shopQtyFmt(int count);

  /// No description provided for @shopAddTitle.
  ///
  /// In zh, this message translates to:
  /// **'加一件'**
  String get shopAddTitle;

  /// No description provided for @shopName.
  ///
  /// In zh, this message translates to:
  /// **'物品名称'**
  String get shopName;

  /// No description provided for @shopQuantity.
  ///
  /// In zh, this message translates to:
  /// **'数量'**
  String get shopQuantity;

  /// No description provided for @shopPrice.
  ///
  /// In zh, this message translates to:
  /// **'预估单价'**
  String get shopPrice;

  /// No description provided for @mediaTitle.
  ///
  /// In zh, this message translates to:
  /// **'书影音'**
  String get mediaTitle;

  /// No description provided for @mediaStatTotal.
  ///
  /// In zh, this message translates to:
  /// **'收藏总数'**
  String get mediaStatTotal;

  /// No description provided for @mediaStatFinished.
  ///
  /// In zh, this message translates to:
  /// **'已看完'**
  String get mediaStatFinished;

  /// No description provided for @mediaStatYearFmt.
  ///
  /// In zh, this message translates to:
  /// **'{year} 观影'**
  String mediaStatYearFmt(int year);

  /// No description provided for @mediaStatusWant.
  ///
  /// In zh, this message translates to:
  /// **'想看'**
  String get mediaStatusWant;

  /// No description provided for @mediaStatusWatching.
  ///
  /// In zh, this message translates to:
  /// **'在看'**
  String get mediaStatusWatching;

  /// No description provided for @mediaStatusFinished.
  ///
  /// In zh, this message translates to:
  /// **'看过'**
  String get mediaStatusFinished;

  /// No description provided for @mediaEmpty.
  ///
  /// In zh, this message translates to:
  /// **'还没有收藏'**
  String get mediaEmpty;

  /// No description provided for @mediaEmptyHint.
  ///
  /// In zh, this message translates to:
  /// **'点右上角 + 添加'**
  String get mediaEmptyHint;

  /// No description provided for @mediaAddTitle.
  ///
  /// In zh, this message translates to:
  /// **'添加收藏'**
  String get mediaAddTitle;

  /// No description provided for @mediaTitleField.
  ///
  /// In zh, this message translates to:
  /// **'标题'**
  String get mediaTitleField;

  /// No description provided for @mediaType.
  ///
  /// In zh, this message translates to:
  /// **'类型'**
  String get mediaType;

  /// No description provided for @mediaStatus.
  ///
  /// In zh, this message translates to:
  /// **'状态'**
  String get mediaStatus;

  /// No description provided for @mediaRating.
  ///
  /// In zh, this message translates to:
  /// **'评分'**
  String get mediaRating;

  /// No description provided for @mediaReview.
  ///
  /// In zh, this message translates to:
  /// **'短评（可选）'**
  String get mediaReview;

  /// No description provided for @mediaTypeBook.
  ///
  /// In zh, this message translates to:
  /// **'书籍'**
  String get mediaTypeBook;

  /// No description provided for @mediaTypeMovie.
  ///
  /// In zh, this message translates to:
  /// **'电影'**
  String get mediaTypeMovie;

  /// No description provided for @mediaTypeSeries.
  ///
  /// In zh, this message translates to:
  /// **'电视剧'**
  String get mediaTypeSeries;

  /// No description provided for @mediaTypeAnime.
  ///
  /// In zh, this message translates to:
  /// **'动漫'**
  String get mediaTypeAnime;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
