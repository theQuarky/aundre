import { Schema, model } from "mongoose";
import { IInteraction, INote, IComment, ITag } from "./INote";

const NoteSchema: Schema<INote> = new Schema(
  {
    note_id: {
      type: String,
      required: true,
      unique: true,
    },
    media_url: {
      type: String,
      required: true,
    },
    caption: {
      type: String,
      default: "",
    },
    tags: {
      type: [String],
      required: true,
      default: [],
    },
    interactions: {
      type: [String],
      required: true,
      default: [],
    },
    comments: {
      type: [String],
      required: true,
      default: [],
    },
    created_by: {
      type: String,
      required: true,
    },
    is_private: {
      type: Boolean,
      required: true,
      default: true,
    },
    is_delete: {
      type: Boolean,
      required: true,
      default: false,
    },
    meta: {
      type: Object,
    },
  },
  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },
    versionKey: false,
  }
);

const InteractionSchema: Schema<IInteraction> = new Schema(
  {
    interaction_id: {
      type: String,
      required: true,
      unique: true,
    },
    note_id: {
      type: String,
      required: true,
    },
    user_id: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      enum: ["like", "dislike", "save", "report"],
      required: true,
    },
    is_delete: {
      type: Boolean,
      required: true,
      default: false,
    },
  },
  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },
    versionKey: false,
  }
);

const CommentSchema: Schema<IComment> = new Schema(
  {
    comment_id: {
      type: String,
      required: true,
      unique: true,
    },
    note_id: {
      type: String,
      required: true,
    },
    user_id: {
      type: String,
      required: true,
    },
    comment: {
      type: String,
      required: true,
    },
    is_delete: {
      type: Boolean,
      required: true,
      default: false,
    },
  },
  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },
    versionKey: false,
  }
);

const TagSchema: Schema<ITag> = new Schema(
  {
    tag_id: {
      type: String,
      required: true,
      unique: true,
    },
    tag: {
      type: String,
      required: true,
    },
    note_id: {
      type: [String],
      required: true,
      default: [],
    },
  },
  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },
    versionKey: false,
  }
);

const NoteModel = model<INote>("Note", NoteSchema);
const InteractionModel = model<IInteraction>("Interaction", InteractionSchema);
const CommentModel = model<IComment>("Comment", CommentSchema);
const TagModel = model<ITag>("Tag", TagSchema);

export { NoteModel, InteractionModel, CommentModel, TagModel };
