"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const model_1 = require("./model");
const userResolver = {
    Query: {
        getNoteById: async (parent, args, context, info) => {
            const { note_id } = args;
            try {
                const note = await model_1.NoteModel.findOne({ note_id });
                if (!note) {
                    return null;
                }
                const comments = await model_1.CommentModel.find({ note_id });
                const like_count = await model_1.InteractionModel.countDocuments({ note_id, type: "like" });
                const dislike_count = await model_1.InteractionModel.countDocuments({ note_id, type: "dislike" });
                const comment_count = await model_1.CommentModel.countDocuments({ note_id });
                return {
                    ...note.toObject(),
                    comments,
                    like_count,
                    dislike_count,
                    comment_count,
                };
            }
            catch (err) {
                return err;
            }
        },
    },
};
exports.default = userResolver;
