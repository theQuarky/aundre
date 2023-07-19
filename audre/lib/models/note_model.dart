class NoteModel {
  final String noteId;
  final String mediaUrl;
  final String caption;
  final List<String> tags;
  final List<String> interactions;
  final List<CommentModel> comments;
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
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      noteId: json['note_id'],
      mediaUrl: json['media_url'],
      caption: json['caption'],
      tags: json['tags'].map<String>((e) => TagModel.fromJson(e)).toList(),
      interactions: json['interactions']
          .map<String>((e) => InteractionModel.fromJson(e))
          .toList(),
      comments: json['comments']
          .map<dynamic>((e) => CommentModel.fromJson(e))
          .toList(),
      isPrivate: json['is_private'],
      createdBy: json['created_by'],
      isDelete: json['is_delete'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class InteractionModel {
  final String interactionId;
  final String noteId;
  final String userId;
  final String type;
  final bool isDelete;
  final String createdAt;
  final String updatedAt;

  InteractionModel({
    required this.interactionId,
    required this.noteId,
    required this.userId,
    required this.type,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InteractionModel.fromJson(Map<String, dynamic> json) {
    return InteractionModel(
      interactionId: json['interaction_id'],
      noteId: json['note_id'],
      userId: json['user_id'],
      type: json['type'],
      isDelete: json['is_delete'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
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
}
