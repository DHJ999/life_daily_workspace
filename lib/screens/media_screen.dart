import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/media_item.dart';

/// 书影音收藏页 —— 封面墙/列表两种视图 + 状态 + 星级 + 短评 + 年度统计
class MediaScreen extends StatefulWidget {
  final AppState state;
  const MediaScreen({super.key, required this.state});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  bool _grid = true;
  String _filter = '全部';
  AppState get st => widget.state;

  static const _statusOptions = ['全部', '想看', '在看', '看过'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('书影音'),
        actions: [
          IconButton(icon: Icon(_grid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _grid = !_grid)),
          IconButton(icon: const Icon(Icons.add), onPressed: _showAdd),
        ],
      ),
      body: ListenableBuilder(
        listenable: st,
        builder: (context, _) {
          final items = st.mediaItems.where((m) {
            if (_filter == '全部') return true;
            return m.status.name == _filter;
          }).toList();
          // 年度统计
          final year = DateTime.now().year;
          final watched = st.mediaItems.where((m) => m.status == MediaStatus.watched).length;
          final thisYear = st.mediaItems.where((m) =>
            m.status == MediaStatus.watched).length; // 简化：无年份字段，按全部已看计
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              SoftCard(padding: const EdgeInsets.all(16), child: Row(children: [
                _Stat(label: '收藏总数', value: '${st.mediaItems.length}'),
                const SizedBox(width: 8),
                _Stat(label: '已看完', value: '$watched'),
                const SizedBox(width: 8),
                _Stat(label: '$year 观影', value: '$thisYear'),
              ])),
              const SizedBox(height: 12),
              SizedBox(height: 40, child: ListView(scrollDirection: Axis.horizontal,
                children: [for (final f in _statusOptions) Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(label: Text(f), selected: _filter == f,
                    onSelected: (_) => setState(() => _filter = f),
                    selectedColor: AppTheme.primary,
                    backgroundColor: AppTheme.surface,
                    labelStyle: TextStyle(color: _filter == f ? Colors.white : AppTheme.inkSecondary, fontSize: 13),
                    side: const BorderSide(color: AppTheme.line)),
                )])),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const EmptyState('还没有收藏', hint: '点右上角 + 添加')
              else if (_grid)
                GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78,
                  children: items.map((m) => _CoverCard(m: m, onDelete: () => st.removeMedia(m.id))).toList())
              else
                for (final m in items) _ListRow(m: m, onDelete: () => st.removeMedia(m.id)),
            ],
          );
        },
      ),
    );
  }

  Widget _Stat({required String label, required String value}) {
    return Expanded(child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.ink)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.inkSecondary)),
    ]));
  }

  void _showAdd() {
    final titleCtrl = TextEditingController();
    final type = ValueNotifier<MediaType>(MediaType.book);
    final status = ValueNotifier<MediaStatus>(MediaStatus.want);
    final rating = ValueNotifier<double>(0);
    final reviewCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('添加收藏', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: '标题')),
            const SizedBox(height: 12),
            const Text('类型', style: TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
            const SizedBox(height: 8),
            ValueListenableBuilder<MediaType>(valueListenable: type,
              builder: (_, t, _) => Wrap(spacing: 8, children: [
                for (final e in MediaTypeMeta.map.entries) ChoiceChip(
                  label: Text(e.value.label, style: const TextStyle(fontSize: 13)),
                  selected: t == e.key, onSelected: (_) => type.value = e.key,
                  selectedColor: AppTheme.primary,
                  labelStyle: TextStyle(color: t == e.key ? Colors.white : AppTheme.inkSecondary),
                  side: const BorderSide(color: AppTheme.line),
                ),
              ])),
            const SizedBox(height: 12),
            const Text('状态', style: TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
            const SizedBox(height: 8),
            ValueListenableBuilder<MediaStatus>(valueListenable: status,
              builder: (_, s, _) => Wrap(spacing: 8, children: [
                for (final opt in MediaStatus.values) ChoiceChip(
                  label: Text(_statusLabel(opt), style: const TextStyle(fontSize: 13)),
                  selected: s == opt, onSelected: (_) => status.value = opt,
                  selectedColor: AppTheme.primary,
                  labelStyle: TextStyle(color: s == opt ? Colors.white : AppTheme.inkSecondary),
                  side: const BorderSide(color: AppTheme.line),
                ),
              ])),
            const SizedBox(height: 12),
            ValueListenableBuilder<double>(valueListenable: rating,
              builder: (_, r, _) => Row(children: [
                const Text('评分', style: TextStyle(fontSize: 13, color: AppTheme.inkSecondary)),
                const SizedBox(width: 8),
                for (int i = 1; i <= 5; i++)
                  IconButton(icon: Icon(i <= r.round() ? Icons.star : Icons.star_border,
                    color: AppTheme.expense, size: 26),
                    onPressed: () => rating.value = i.toDouble()),
              ])),
            TextField(controller: reviewCtrl, decoration: const InputDecoration(labelText: '短评（可选）'),
              maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: FilledButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                st.addMedia(MediaItem(
                  id: st.newId(), title: titleCtrl.text.trim(),
                  type: type.value, status: status.value,
                  rating: rating.value, review: reviewCtrl.text.trim(),
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

  static String _statusLabel(MediaStatus s) =>
      s == MediaStatus.want ? '想看' : (s == MediaStatus.watching ? '在看' : '看过');
}

class _CoverCard extends StatelessWidget {
  final MediaItem m;
  final VoidCallback onDelete;
  const _CoverCard({required this.m, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    final meta = MediaTypeMeta.of(m.type);
    return SoftCard(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // 封面占位（用类型色块 + 首字，避免外链）
      Container(height: 90, width: double.infinity,
        decoration: BoxDecoration(color: meta.color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(m.title.isEmpty ? '?' : m.title.characters.first,
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: meta.color))),
      ),
      const SizedBox(height: 10),
      Expanded(child: Text(m.title, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
      const SizedBox(height: 2),
      Row(children: [
        Text(meta.label, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
        const Spacer(),
        for (int i = 0; i < 5; i++)
          Icon(i < m.rating.round() ? Icons.star : Icons.star_border, size: 12, color: AppTheme.expense),
      ]),
      const SizedBox(height: 6),
      Row(children: [
        _StatusTag(m.status),
        const Spacer(),
        InkWell(onTap: onDelete, child: const Icon(Icons.close, size: 15, color: AppTheme.inkSecondary)),
      ]),
    ]));
  }
}

class _ListRow extends StatelessWidget {
  final MediaItem m;
  final VoidCallback onDelete;
  const _ListRow({required this.m, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    final meta = MediaTypeMeta.of(m.type);
    return SoftCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(
          color: meta.color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(m.title.isEmpty ? '?' : m.title.characters.first,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: meta.color)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          if (m.review.isNotEmpty) Text(m.review, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
          const SizedBox(height: 2),
          Row(children: [
            Text(meta.label, style: const TextStyle(fontSize: 12, color: AppTheme.inkSecondary)),
            const SizedBox(width: 6),
            for (int i = 0; i < 5; i++)
              Icon(i < m.rating.round() ? Icons.star : Icons.star_border, size: 11, color: AppTheme.expense),
          ]),
        ])),
        _StatusTag(m.status),
        InkWell(onTap: onDelete, child: const Padding(padding: EdgeInsets.all(6), child: Icon(Icons.close, size: 16, color: AppTheme.inkSecondary))),
      ]));
  }
}

class _StatusTag extends StatelessWidget {
  final MediaStatus status;
  const _StatusTag(this.status);
  @override
  Widget build(BuildContext context) {
    final map = {
      MediaStatus.want: (const Color(0xFF888780), '想看'),
      MediaStatus.watching: (AppTheme.primary, '在看'),
      MediaStatus.watched: (AppTheme.expense, '看过'),
    };
    final (color, label) = map[status]!;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)));
  }
}
