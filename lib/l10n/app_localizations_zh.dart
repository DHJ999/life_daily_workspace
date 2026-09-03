// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '日常集';

  @override
  String get appNameFull => '日常集 · 生活工作台';

  @override
  String get navToday => '今日';

  @override
  String get navMoney => '记账';

  @override
  String get navHabits => '习惯';

  @override
  String get navFitness => '减脂';

  @override
  String get navPlan => '日程';

  @override
  String get navShopping => '待买';

  @override
  String get navMedia => '书影音';

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => '取消';

  @override
  String get commonAll => '全部';

  @override
  String get commonNote => '备注（可选）';

  @override
  String get dashToday => '今天要处理';

  @override
  String get dashStatExpense => '今日支出';

  @override
  String get dashStatIncome => '今日收入';

  @override
  String get dashStatHabit => '习惯完成';

  @override
  String get dashQuick => '快捷入口';

  @override
  String get dashAllDone => '今天的事都处理完了，可以歇一歇';

  @override
  String dashTodoCountFmt(int count) {
    return '$count 件';
  }

  @override
  String dashOverdueFmt(String title) {
    return '逾期：$title';
  }

  @override
  String dashTodayItemFmt(String title) {
    return '今日：$title';
  }

  @override
  String dashToBuyFmt(String name, int qty) {
    return '待买：$name ×$qty';
  }

  @override
  String dashModMoneyFmt(int count) {
    return '$count 条';
  }

  @override
  String dashModHabitFmt(int count) {
    return '$count 个习惯';
  }

  @override
  String dashModFitnessFmt(int count) {
    return '$count 条记录';
  }

  @override
  String dashModPlanFmt(int count) {
    return '$count 件事';
  }

  @override
  String dashModShoppingFmt(int count) {
    return '$count 件待买';
  }

  @override
  String dashModMediaFmt(int count) {
    return '$count 部';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsStorage => '数据存储';

  @override
  String get settingsStorageSub => '当前：本地存储';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsLanguageSub => '界面显示语言，简体中文或英文';

  @override
  String get moneyTitle => '记账理财';

  @override
  String get moneyMonthExpense => '本月支出';

  @override
  String get moneyMonthIncome => '本月收入';

  @override
  String get moneyBalance => '结余';

  @override
  String get moneyEmptyMonth => '本月还没有记录';

  @override
  String get moneyEmptyMonthHint => '点右上角 + 记一笔';

  @override
  String get moneyEmptyCat => '该分类暂无记录';

  @override
  String get moneyAddTitle => '记一笔';

  @override
  String get moneyExpense => '支出';

  @override
  String get moneyIncome => '收入';

  @override
  String get moneyAmount => '金额';

  @override
  String get moneyPieTitle => '消费结构';

  @override
  String get habitsTitle => '习惯健康';

  @override
  String get habitsEmpty => '还没有习惯';

  @override
  String get habitsEmptyHint => '点右上角 + 新建一个习惯';

  @override
  String get habitsMy => '我的习惯';

  @override
  String get habitsHeat => '30 天热力图';

  @override
  String get habitsAddTitle => '新建习惯';

  @override
  String get habitsName => '习惯名称';

  @override
  String get habitsNameHint => '如：早起、喝水、跑步';

  @override
  String get habitsTypeLabel => '打卡方式';

  @override
  String get habitsChipCheck => '勾选';

  @override
  String get habitsChipCounter => '计数';

  @override
  String get habitsChipValue => '数值';

  @override
  String get habitsTarget => '目标';

  @override
  String get habitsUnit => '单位（可选）';

  @override
  String get habitsCreate => '创建';

  @override
  String get habitsDoneStatus => '完成/未完成';

  @override
  String habitsTargetFmt(String target) {
    return '目标 $target';
  }

  @override
  String habitsStreakFmt(int days) {
    return '连续 $days 天';
  }

  @override
  String get heatLow => '少';

  @override
  String get heatHigh => '多';

  @override
  String get heatLast30 => '近 30 天';

  @override
  String heatTooltipFmt(String date, String pct) {
    return '$date $pct%';
  }

  @override
  String get fitnessTitle => '减脂健身';

  @override
  String get fitnessTrend => '体重趋势（含 7 日均线）';

  @override
  String get fitnessTrendHint => '至少录入 2 条体重记录后显示趋势';

  @override
  String get fitnessAddTitle => '记录体重体脂';

  @override
  String get fitnessWeight => '体重（kg）';

  @override
  String get fitnessBodyFat => '体脂率（%）';

  @override
  String get fitnessGoalTitle => '目标设置';

  @override
  String get fitnessGoalWeight => '目标体重（kg）';

  @override
  String get fitnessHeight => '身高（cm，用于 BMI）';

  @override
  String get fitnessCalorie => '每日热量目标（kcal）';

  @override
  String get fitnessCurWeight => '当前体重';

  @override
  String get fitnessBmi => 'BMI';

  @override
  String get fitnessGoalWeightShort => '目标体重';

  @override
  String get bmiThin => '偏瘦';

  @override
  String get bmiNormal => '正常';

  @override
  String get bmiOver => '偏胖';

  @override
  String get bmiObese => '肥胖';

  @override
  String fitnessProgressFmt(int pct) {
    return '已达成 $pct%';
  }

  @override
  String fitnessCalorieGoalFmt(int kcal) {
    return '热量目标 $kcal kcal/日';
  }

  @override
  String fitnessFatFmt(String fat) {
    return '体脂 $fat%';
  }

  @override
  String get planTitle => '日程统筹';

  @override
  String get planEmpty => '这一天还没有日程';

  @override
  String get planAddTitle => '新增日程';

  @override
  String get planItemField => '事项';

  @override
  String get planDate => '日期';

  @override
  String get planType => '类型';

  @override
  String get shopTitle => '待买清单';

  @override
  String get shopTotal => '待买合计';

  @override
  String get shopShowBought => '显示已买';

  @override
  String get shopEmptyTodo => '待买清单是空的';

  @override
  String get shopEmptyBought => '还没有已买记录';

  @override
  String get shopEmptyHint => '点右上角 + 加一件';

  @override
  String shopQtyFmt(int count) {
    return '$count 件';
  }

  @override
  String get shopAddTitle => '加一件';

  @override
  String get shopName => '物品名称';

  @override
  String get shopQuantity => '数量';

  @override
  String get shopPrice => '预估单价';

  @override
  String get mediaTitle => '书影音';

  @override
  String get mediaStatTotal => '收藏总数';

  @override
  String get mediaStatFinished => '已看完';

  @override
  String mediaStatYearFmt(int year) {
    return '$year 观影';
  }

  @override
  String get mediaStatusWant => '想看';

  @override
  String get mediaStatusWatching => '在看';

  @override
  String get mediaStatusFinished => '看过';

  @override
  String get mediaEmpty => '还没有收藏';

  @override
  String get mediaEmptyHint => '点右上角 + 添加';

  @override
  String get mediaAddTitle => '添加收藏';

  @override
  String get mediaTitleField => '标题';

  @override
  String get mediaType => '类型';

  @override
  String get mediaStatus => '状态';

  @override
  String get mediaRating => '评分';

  @override
  String get mediaReview => '短评（可选）';

  @override
  String get mediaTypeBook => '书籍';

  @override
  String get mediaTypeMovie => '电影';

  @override
  String get mediaTypeSeries => '电视剧';

  @override
  String get mediaTypeAnime => '动漫';
}
