"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TagModel = exports.CommentModel = exports.InteractionModel = exports.NoteModel = void 0;
const mongoose_1 = require("mongoose");
const NoteSchema = new mongoose_1.Schema({
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
}, {
    timestamps: {
        createdAt: "created_at",
        updatedAt: "updated_at",
    },
    versionKey: false,
});
const InteractionSchema = new mongoose_1.Schema({
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
}, {
    timestamps: {
        createdAt: "created_at",
        updatedAt: "updated_at",
    },
    versionKey: false,
});
const CommentSchema = new mongoose_1.Schema({
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
}, {
    timestamps: {
        createdAt: "created_at",
        updatedAt: "updated_at",
    },
    versionKey: false,
});
const TagSchema = new mongoose_1.Schema({
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
}, {
    timestamps: {
        createdAt: "created_at",
        updatedAt: "updated_at",
    },
    versionKey: false,
});
const NoteModel = (0, mongoose_1.model)("Note", NoteSchema);
exports.NoteModel = NoteModel;
const InteractionModel = (0, mongoose_1.model)("Interaction", InteractionSchema);
exports.InteractionModel = InteractionModel;
const CommentModel = (0, mongoose_1.model)("Comment", CommentSchema);
exports.CommentModel = CommentModel;
const TagModel = (0, mongoose_1.model)("Tag", TagSchema);
exports.TagModel = TagModel;
