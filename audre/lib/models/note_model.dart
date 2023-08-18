class NoteModel {
  final String noteId;
  final String mediaUrl;
  final String caption;
  final List<String> tags;
  final List<dynamic> interactions;
  final List<String> comments;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final bool isPrivate;
  final String createdBy;
  final bool isDelete;
  final String createdAt;
  final String updatedAt;

  NoteModel({
    required this.noteId,
    required this.mediaUrl,
    required this.caption,
    required this.tags,
    required this.interactions,
    required this.comments,
    required this.isPrivate,
    required this.createdBy,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.commentCount = 0,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      noteId: json['note_id'],
      mediaUrl: json['media_url'] ?? '',
      caption: json['caption'] ?? '',
      tags: [],
      interactions: json['interactions']
          .map<dynamic>((e) => InteractionModel.fromJson(e))
          .toList(),
      comments: [],
      isPrivate: json['is_private'] ?? false,
      createdBy: json['created_by'] ?? '',
      isDelete: json['is_delete'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      likeCount: json['like_count'] ?? 0,
      dislikeCount: json['dislike_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note_id': noteId,
      'media_url': mediaUrl,
      'caption': caption,
      'tags': tags,
      'interactions': interactions,
      'comments': comments,
      'is_private': isPrivate,
      'created_by': createdBy,
      'is_delete': isDelete,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'like_count': likeCount,
      'dislike_count': dislikeCount,
      'comment_count': commentCount,
    };
  }

  void toLocalString() {
    print(toJson());
  }
}

class InteractionModel {
  final String interactionId;
  final String noteId;
  final String userId;
  final String type;
  final String createdAt;

  InteractionModel({
    required this.interactionId,
    required this.noteId,
    required this.userId,
    required this.type,
    required this.createdAt,
  });

  factory InteractionModel.fromJson(Map<String, dynamic> json) {
    return InteractionModel(
      interactionId: json['interaction_id'],
      noteId: json['note_id'],
      userId: json['user_id'],
      type: json['type'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interaction_id': interactionId,
      'note_id': noteId,
      'user_id': userId,
      'type': type,
      'created_at': createdAt,
    };
  }

  void toLocalString() {
    print(toJson());
  }
}

class CommentModel {
  final String commentId;
  final String noteId;
  final String userId;
  final String comment;
  final bool isDelete;
  final String createdAt;
  final String updatedAt;

  CommentModel({
    required this.commentId,
    required this.noteId,
    required this.userId,
    required this.comment,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['comment_id'],
      noteId: json['note_id'],
      userId: json['user_id'],
      comment: json['comment'],
      isDelete: json['is_delete'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'note_id': noteId,
      'user_id': userId,
      'comment': comment,
      'is_delete': isDelete,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  void toLocalString() {
    print(toJson());
  }
}

class TagModel {
  final String tagId;
  final String tag;
  final List<String> noteId;

  TagModel({
    required this.tagId,
    required this.tag,
    required this.noteId,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tag_id'],
      tag: json['tag'],
      noteId: json['note_id'].map<String>((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tag_id': tagId,
      'tag': tag,
      'note_id': noteId,
    };
  }

  void toLocalString() {
    print(toJson());
  }
}
