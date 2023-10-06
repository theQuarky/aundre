import { Schema, model } from "mongoose";

const MessageSchema: Schema<any> = new Schema(
  {
    message_id: {
      type: String,
      required: true,
      unique: true,
    },
    chat_id: {
      type: String,
      required: true,
      unique: false,
    },
    sender: {
      type: String,
      required: true,
    },
    receiver: {
      type: String,
      required: true,
    },
    message: {
      type: String,
      required: false,
      default: "",
    },
    is_delete: {
      type: Boolean,
      required: true,
      default: false,
    },
    media: {
      type: String,
      required: false,
    },
    seenBy: {
      type: Array,
      required: false,
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

const ChatSchema: Schema<any> = new Schema(
  {
    chat_id: {
      type: String,
      required: true,
      unique: true,
    },
    messages: {
      type: [String],
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

const ChatModel = model<any>("chats", ChatSchema);
const MessageModel = model<any>("messages", MessageSchema);

export { ChatModel, MessageModel };
