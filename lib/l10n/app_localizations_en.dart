// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LifeDaily';

  @override
  String get appNameFull => 'LifeDaily · Life Workbench';

  @override
  String get navToday => 'Today';

  @override
  String get navMoney => 'Money';

  @override
  String get navHabits => 'Habits';

  @override
  String get navFitness => 'Fitness';

  @override
  String get navPlan => 'Planner';

  @override
  String get navShopping => 'To-buy';

  @override
  String get navMedia => 'Media';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonAll => 'All';

  @override
  String get commonNote => 'Note (optional)';

  @override
  String get dashToday => 'To handle today';

  @override
  String get dashStatExpense => 'Expenses today';

  @override
  String get dashStatIncome => 'Income today';

  @override
  String get dashStatHabit => 'Habits done';

  @override
  String get dashQuick => 'Quick access';

  @override
  String get dashAllDone => 'Everything is done for today. Take a break.';

  @override
  String dashTodoCountFmt(int count) {
    return '$count items';
  }

  @override
  String dashOverdueFmt(String title) {
    return 'Overdue: $title';
  }

  @override
  String dashTodayItemFmt(String title) {
    return 'Today: $title';
  }

  @override
  String dashToBuyFmt(String name, int qty) {
    return 'To-buy: $name ×$qty';
  }

  @override
  String dashModMoneyFmt(int count) {
    return '$count entries';
  }

  @override
  String dashModHabitFmt(int count) {
    return '$count habits';
  }

  @override
  String dashModFitnessFmt(int count) {
    return '$count records';
  }

  @override
  String dashModPlanFmt(int count) {
    return '$count items';
  }

  @override
  String dashModShoppingFmt(int count) {
    return '$count to buy';
  }

  @override
  String dashModMediaFmt(int count) {
    return '$count titles';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsStorage => 'Data storage';

  @override
  String get settingsStorageSub => 'Currently: stored locally';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLanguageSub =>
      'UI language: Simplified Chinese or English';

  @override
  String get moneyTitle => 'Money & Budgets';

  @override
  String get moneyMonthExpense => 'Spent this month';

  @override
  String get moneyMonthIncome => 'Earned this month';

  @override
  String get moneyBalance => 'Balance';

  @override
  String get moneyEmptyMonth => 'No records this month';

  @override
  String get moneyEmptyMonthHint => 'Tap + to add a record';

  @override
  String get moneyEmptyCat => 'No records in this category';

  @override
  String get moneyAddTitle => 'Add a record';

  @override
  String get moneyExpense => 'Expense';

  @override
  String get moneyIncome => 'Income';

  @override
  String get moneyAmount => 'Amount';

  @override
  String get moneyPieTitle => 'Spending breakdown';

  @override
  String get habitsTitle => 'Habits & Health';

  @override
  String get habitsEmpty => 'No habits yet';

  @override
  String get habitsEmptyHint => 'Tap + to create a habit';

  @override
  String get habitsMy => 'My habits';

  @override
  String get habitsHeat => 'Last 30 days heatmap';

  @override
  String get habitsAddTitle => 'New habit';

  @override
  String get habitsName => 'Habit name';

  @override
  String get habitsNameHint => 'e.g. Water, Running, Reading';

  @override
  String get habitsTypeLabel => 'Check-in type';

  @override
  String get habitsChipCheck => 'Check';

  @override
  String get habitsChipCounter => 'Counter';

  @override
  String get habitsChipValue => 'Value';

  @override
  String get habitsTarget => 'Target';

  @override
  String get habitsUnit => 'Unit (optional)';

  @override
  String get habitsCreate => 'Create';

  @override
  String get habitsDoneStatus => 'Done / Not done';

  @override
  String habitsTargetFmt(String target) {
    return 'Target $target';
  }

  @override
  String habitsStreakFmt(int days) {
    return '$days-day streak';
  }

  @override
  String get heatLow => 'Less';

  @override
  String get heatHigh => 'More';

  @override
  String get heatLast30 => 'Last 30 days';

  @override
  String heatTooltipFmt(String date, String pct) {
    return '$date $pct%';
  }

  @override
  String get fitnessTitle => 'Fitness';

  @override
  String get fitnessTrend => 'Weight trend (7-day average)';

  @override
  String get fitnessTrendHint =>
      'Add at least 2 weight records to see the trend';

  @override
  String get fitnessAddTitle => 'Log weight & body fat';

  @override
  String get fitnessWeight => 'Weight (kg)';

  @override
  String get fitnessBodyFat => 'Body fat (%)';

  @override
  String get fitnessGoalTitle => 'Goal settings';

  @override
  String get fitnessGoalWeight => 'Target weight (kg)';

  @override
  String get fitnessHeight => 'Height (cm, for BMI)';

  @override
  String get fitnessCalorie => 'Daily calorie goal (kcal)';

  @override
  String get fitnessCurWeight => 'Current';

  @override
  String get fitnessBmi => 'BMI';

  @override
  String get fitnessGoalWeightShort => 'Target';

  @override
  String get bmiThin => 'Underweight';

  @override
  String get bmiNormal => 'Normal';

  @override
  String get bmiOver => 'Overweight';

  @override
  String get bmiObese => 'Obese';

  @override
  String fitnessProgressFmt(int pct) {
    return '$pct% achieved';
  }

  @override
  String fitnessCalorieGoalFmt(int kcal) {
    return 'Calorie goal $kcal kcal/day';
  }

  @override
  String fitnessFatFmt(String fat) {
    return 'Body fat $fat%';
  }

  @override
  String get planTitle => 'Planner';

  @override
  String get planEmpty => 'No plans for this day';

  @override
  String get planAddTitle => 'New plan';

  @override
  String get planItemField => 'Item';

  @override
  String get planDate => 'Date';

  @override
  String get planType => 'Type';

  @override
  String get shopTitle => 'Shopping list';

  @override
  String get shopTotal => 'To-buy total';

  @override
  String get shopShowBought => 'Show bought';

  @override
  String get shopEmptyTodo => 'Nothing to buy';

  @override
  String get shopEmptyBought => 'No bought items yet';

  @override
  String get shopEmptyHint => 'Tap + to add an item';

  @override
  String shopQtyFmt(int count) {
    return '$count pcs';
  }

  @override
  String get shopAddTitle => 'Add item';

  @override
  String get shopName => 'Item name';

  @override
  String get shopQuantity => 'Quantity';

  @override
  String get shopPrice => 'Est. unit price';

  @override
  String get mediaTitle => 'Media';

  @override
  String get mediaStatTotal => 'Total';

  @override
  String get mediaStatFinished => 'Finished';

  @override
  String mediaStatYearFmt(int year) {
    return 'Watched in $year';
  }

  @override
  String get mediaStatusWant => 'Want';

  @override
  String get mediaStatusWatching => 'In progress';

  @override
  String get mediaStatusFinished => 'Finished';

  @override
  String get mediaEmpty => 'Nothing collected yet';

  @override
  String get mediaEmptyHint => 'Tap + to add';

  @override
  String get mediaAddTitle => 'Add to collection';

  @override
  String get mediaTitleField => 'Title';

  @override
  String get mediaType => 'Type';

  @override
  String get mediaStatus => 'Status';

  @override
  String get mediaRating => 'Rating';

  @override
  String get mediaReview => 'Review (optional)';

  @override
  String get mediaTypeBook => 'Book';

  @override
  String get mediaTypeMovie => 'Movie';

  @override
  String get mediaTypeSeries => 'Series';

  @override
  String get mediaTypeAnime => 'Anime';
}
