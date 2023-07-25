import { Document } from "mongoose";
import { INote, IComment, IInteraction, ITag } from "./INote";
import { NoteModel, CommentModel, InteractionModel, TagModel } from "./model";

const userResolver = {
  Query: {
    getNoteById: async (parent: any, args: any, context: any, info: any) => {
      const { note_id } = args;
      try {
        const note: Partial<INote> = (
          await NoteModel.findOne({
            note_id,
            is_delete: false,
          })
        )?.toObject();

        if (!note) {
          return null;
        }

        const like_count: Number = await InteractionModel.countDocuments({
          note_id,
          type: "like",
          is_delete: false,
        });
        const dislike_count: Number = await InteractionModel.countDocuments({
          note_id,
          type: "dislike",
          is_delete: false,
        });
        const comment_count: Number = await CommentModel.countDocuments({
          note_id,
          is_delete: false,
        });

        const interactions: Partial<IInteraction>[] = (
          await InteractionModel.find({
            note_id,
            is_delete: false,
          })
        ).map((e) => e.toObject());

        return {
          ...note,
          like_count,
          interactions,
          dislike_count,
          comment_count,
        };
      } catch (err) {
        return err;
      }
    },
    getNoteComments: async (
      parent: any,
      args: any,
      context: any,
      info: any
    ) => {
      const { note_id } = args;
      try {
        const comments: Partial<IComment>[] = await CommentModel.aggregate([
          {
            $match: {
              note_id,
              is_delete: false,
            },
          },
          {
            $lookup: {
              from: "users",
              localField: "user_id",
              foreignField: "uid",
              as: "user",
            },
          },
          {
            $unwind: "$user",
          },
          {
            $project: {
              _id: 0,
              comment_id: 1,
              note_id: 1,
              user_id: 1,
              comment: 1,
              created_at: 1,
              updated_at: 1,
              "user.uid": 1,
              "user.username": 1,
              "user.profile_pic": 1,
            },
          },
        ]);

        console.log(comments);
        return comments;
      } catch (err) {
        return err;
      }
    },
  },
};

export default userResolver;
