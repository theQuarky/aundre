import { Document } from "mongoose";
import { INote, IComment, IInteraction, ITag } from "./INote";
import { NoteModel, CommentModel, InteractionModel, TagModel } from "./model";



const userResolver = {
  Query: {
    getNoteById: async (parent: any, args: any, context: any, info: any) => {
      const { note_id } = args;
      try {
        const note: any = await NoteModel.findOne({ note_id });

        if(!note) {
          return null;
        }

        const comments = await CommentModel.find({ note_id });
        const like_count = await InteractionModel.countDocuments({ note_id, type: "like" });
        const dislike_count = await InteractionModel.countDocuments({ note_id, type: "dislike" });
        const comment_count = await CommentModel.countDocuments({ note_id });

        return {
          ...note.toObject(),
          comments,
          like_count,
          dislike_count,
          comment_count,
        };

      } catch (err) {
        return err;
      }
    },
  },
};

export default userResolver;
