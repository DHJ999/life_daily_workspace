import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/shopping_item.dart';

/// 待买清单页
class ShoppingScreen extends StatefulWidget {
  final AppState state;
  const ShoppingScreen({super.key, required this.state});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  bool _showBought = false;
  AppState get st => widget.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('待买清单'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _showAdd)],
      ),
      body: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final items = st.shoppingItems.where((s) => _showBought ? true : !s.bought).toList();
          final total = items.where((s) => !s.bought).fold(0.0, (a, s) => a + s.totalPrice);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              if (!_showBought) SoftCard(padding: const EdgeInsets.all(16),
                child: Row(children: [
                  const Icon(Icons.receipt_long_outlined, color: AppTheme.primary),
                  const SizedBox(width: 12),
                  Text('待买合计', style: const TextStyle(fontSize: 14, color: AppTheme.inkSecondary)),
                  const Spacer(),
                  Text(fmtMoney(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ])),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _showBought,
                onChanged: (v) => setState(() => _showBought = v),
                title: const Text('显示已买', style: TextStyle(fontSize: 14)),
                activeThumbColor: AppTheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
              if (items.isEmpty)
                EmptyState(_showBought ? '还没有已买记录' : '待买清单是空的', hint: '点右上角 + 加一件')
              else
                for (final s in items) _ItemRow(s: s),
            ],
          );
        },
      ),
    );
  }

  Widget _ItemRow({required ShoppingItem s}) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Checkbox(
          value: s.bought,
          onChanged: (_) => st.toggleShopping(s.id),
          activeColor: AppTheme.primary,
        ),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
              decoration: s.bought ? TextDecoration.lineThrough : null,
              color: s.bought ? AppTheme.inkSecondary : AppTheme.ink)),
          if (s.note.isNotEmpty) Text(s.note, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${s.quantity} 件', style: const TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
          Text(fmtMoney(s.totalPrice), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ]),
        InkWell(onTap: () => st.removeShopping(s.id),
          child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.close, size: 16, color: AppTheme.inkSecondary))),
      ]),
    );
  }

  void _showAdd() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1');
    final priceCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('加一件', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: '物品名称')),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: qtyCtrl, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '数量'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: priceCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: '预估单价', prefixText: '¥ '))),
            ]),
            const SizedBox(height: 12),
            TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: '备注（可选）')),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                st.addShopping(ShoppingItem(
                  id: st.newId(),
                  name: nameCtrl.text.trim(),
                  quantity: int.tryParse(qtyCtrl.text) ?? 1,
                  price: double.tryParse(priceCtrl.text) ?? 0,
                  note: noteCtrl.text,
                ));
                Navigator.pop(ctx);
              },
              child: const Text('保存'),
            )),
          ]),
        ),
      ),
    );
  }
}
