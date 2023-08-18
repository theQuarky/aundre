import { Document } from "mongoose";
import { INote, IComment, IInteraction, ITag } from "./INote";
import UserModel from "../users/model";
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

        return comments;
      } catch (err) {
        return err;
      }
    },
    getFeed: async (parent: any, args: any, context: any, info: any) => {
      try {
        const { uid, page = 1, perPage = 10 } = args; 

        const skip = (page - 1) * perPage;

        const followingUserIds: string[] = await UserModel.findOne({ uid })
          .select("following")
          .lean()
          .then((res: any) => res.following);
        let notes: any = await NoteModel.find({
          created_by: { $in: followingUserIds },
          is_delete: false,
        })
          .lean()
          .sort({ created_at: -1 })
          .skip(skip)
          .limit(perPage);

        async function getInteractions(note: any) {
          const noteId = note.note_id;

          const [interactionCounts, interactions] = await Promise.all([
            InteractionModel.aggregate([
              {
                $match: {
                  note_id: noteId,
                  is_delete: false,
                },
              },
              {
                $group: {
                  _id: "$type",
                  count: { $sum: 1 },
                },
              },
            ]),
            InteractionModel.find({
              note_id: noteId,
              is_delete: false,
            }).lean(),
          ]);

          const interactionCountsMap = interactionCounts.reduce(
            (map: any, item: any) => {
              map[item._id] = item.count;
              return map;
            },
            {}
          );

          return {
            ...note,
            interactions,
            like_count: interactionCountsMap["like"] || 0,
            dislike_count: interactionCountsMap["dislike"] || 0,
            comment_count: interactionCountsMap["comment"] || 0,
          };
        }
        notes = await Promise.all(notes.map(getInteractions));
        // const notes = await UserModel.aggregate([
        //   {
        //     $match: {
        //       uid,
        //     },
        //   },
        //   {
        //     $lookup: {
        //       from: "notes",
        //       let: {
        //         followingUserIds: "$following",
        //         currentUser: "$uid",
        //       },
        //       as: "notes",
        //       pipeline: [
        //         {
        //           $match: {
        //             $expr: {
        //               $or: [
        //                 {
        //                   $in: ["$created_by", "$$followingUserIds"],
        //                 },
        //                 {
        //                   $and: [
        //                     { $eq: ["$created_by", "$$currentUser"] },
        //                     { $eq: ["$is_public", true] },
        //                     { $eq: ["$is_delete", false] },
        //                   ],
        //                 },
        //               ],
        //             },
        //           },
        //         },
        //         { $sort: { created_at: -1 } },
        //         { $skip: skip },
        //         { $limit: perPage },
        //       ],
        //     },
        //   },
        //   {
        //     $lookup: {
        //       from: "interactions",
        //       let: {
        //         noteIds: "$notes.note_id",
        //         currentUser: "$uid",
        //       },
        //       as: "notes.interactions",
        //       // pipeline to fetch all interactions for the notes where interaction's note_id match with note's note_id
        //       pipeline: [
        //         {
        //           $match: {
        //             $expr: {
        //               $and: [
        //                 {
        //                   $in: ["$note_id", "$$noteIds"],
        //                 },
        //                 {
        //                   $eq: ["$is_delete", false],
        //                 }
        //               ],
        //             },
        //           },
        //         },
        //       ],
        //     },
        //   },
        // ]);
        return notes;
      } catch (error) {
        console.log(error);
      }
    },
  },
};

export default userResolver;
