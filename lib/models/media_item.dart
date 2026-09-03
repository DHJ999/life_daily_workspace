import 'package:flutter/material.dart';

/// 书影音类型
enum MediaType { book, movie, series, anime }

/// 收藏状态
enum MediaStatus { want, watching, watched }

/// 书影音收藏
class MediaItem {
  final String id;
  final String title;
  final MediaType type;
  final MediaStatus status;
  final double rating; // 0-5
  final String review;

  const MediaItem({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.rating = 0,
    this.review = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'status': status.name,
        'rating': rating,
        'review': review,
      };

  factory MediaItem.fromJson(Map<String, dynamic> json) => MediaItem(
        id: json['id'] as String,
        title: json['title'] as String,
        type: MediaType.values.firstWhere((t) => t.name == json['type'],
            orElse: () => MediaType.book),
        status: MediaStatus.values.firstWhere((s) => s.name == json['status'],
            orElse: () => MediaStatus.want),
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        review: json['review'] as String? ?? '',
      );
}

class MediaTypeMeta {
  final MediaType type;
  final String label;
  final IconData icon;
  final Color color;
  const MediaTypeMeta(this.type, this.label, this.icon, this.color);
  static const Map<MediaType, MediaTypeMeta> map = {
    MediaType.book: MediaTypeMeta(MediaType.book, '书籍', Icons.menu_book, Color(0xFF185FA5)),
    MediaType.movie: MediaTypeMeta(MediaType.movie, '电影', Icons.movie, Color(0xFFD4537E)),
    MediaType.series: MediaTypeMeta(MediaType.series, '电视剧', Icons.tv, Color(0xFF1D9E75)),
    MediaType.anime: MediaTypeMeta(MediaType.anime, '动漫', Icons.animation, Color(0xFF7F77DD)),
  };
  static MediaTypeMeta of(MediaType t) => map[t]!;
}
