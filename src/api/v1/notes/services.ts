import { NextFunction, RequestHandler } from "express";
import IRequest from "../IRequest";
import IResponse from "../IResponse";
import _, { update } from "lodash";
import { CommentModel, InteractionModel, NoteModel, TagModel } from "./model";
import { IComment, IInteraction, INote, ITag } from "./INote";
import { v4 as uuidv4 } from "uuid";
import { extractHashtags, isValidFirebaseAudioUrl } from "../helpers";
import IUser from "../users/IUser";
import UserModel from "../users/model";
import { extra } from "http-status";

// write function to validate and insert note in database use same logic as instagram post creation

// validation middleware
export const validateCreateData: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { media_url, created_by } = _.merge(req.body, req.params);

  if (!media_url) {
    return res.status(400).json({
      success: false,
      message: "media_url is required",
    });
  }

  if (!created_by) {
    return res.status(400).json({
      success: false,
      message: "created_by is required",
    });
  }

  next();
};

export const validateMediaUrl: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { media_url } = _.merge(req.body, req.params);

  // write logic to validate media_url is valid url
  if (!isValidFirebaseAudioUrl(media_url)) {
    return res.status(400).json({
      error:
        "Invalid media_url. Please provide a valid Firebase Storage URL for audio content.",
    });
  }
  next();
};

export const validateUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { created_by } = _.merge(req.body, req.params);
  // write logic to validate user is valid
  try {
    const user: IUser | any = await UserModel.findOne({
      uid: created_by,
    });
    if (!user) {
      return res.status(400).json({
        success: false,
        message: "user is not exist",
      });
    }
    req.user = user;
    return next();
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Something went wrong",
    });
  }
};

export const processCaption: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { caption } = _.merge(req.body, req.params);

  if (!caption) {
    return next();
  }
  const tags: string[] = extractHashtags(caption);

  // other processing for future
  req.note = {
    tags: tags,
  };
  next();
};

export const createTags: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  if (!req?.note?.tags) {
    return next();
  }
  const { tags } = req.note;
  // Function to check if a tag exists in the database and create it if it doesn't
  async function findOrCreateTag(tag: string) {
    try {
      const existingTag: Partial<ITag> = await TagModel.findOne({ tag }).exec();
      if (existingTag) {
        return existingTag.tag_id;
      } else {
        const newTag = await TagModel.create({ tag_id: uuidv4(), tag });
        return newTag.tag_id;
      }
    } catch (error) {
      console.error("Error creating or fetching tags:", error);
      throw new Error("Tag creation failed.");
    }
  }

  try {
    // Use Promise.all to execute the findOrCreateTag function for all tags concurrently
    const tagIds = await Promise.all(tags.map(findOrCreateTag));

    // Update the note's tag_ids with the new or existing tag IDs
    req.note.tags = tagIds;

    next();
  } catch (error) {
    return res.status(500).json({ error: "Tag creation failed." });
  }
};

export const createNote: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { media_url, created_by, caption } = _.merge(req.body, req.params);
  let tags = [];
  if (!req.note?.tags) {
    tags = [];
  } else {
    tags = req?.note?.tags;
  }
  try {
    const data: Partial<INote> = {
      note_id: uuidv4(),
      media_url,
      created_by,
      caption,
      tags,
    };
    const note: Partial<INote> = await NoteModel.create(data);
    req.note = note;
    next();
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Note creation failed." });
  }
};

export const updateTags: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { tags } = req.note;
  const { note_id } = req.note;

  try {
    await TagModel.updateMany(
      { tag_id: { $in: tags } },
      { $addToSet: { note_id: note_id } }
    );
    next();
  } catch (error) {
    return res.status(500).json({ error: "Tag update failed." });
  }
};

export const returnNote: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { note } = req;
  res.status(200).json({
    success: true,
    message: "Note created successfully",
    data: note,
  });
};
export const validateCommentData: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const params = _.merge(req.body, req.params);

  if (!params?.comment_text) {
    return res.status(400).json({
      success: false,
      message: "comment_text is required",
    });
  }
  if (!params?.note_id) {
    return res.status(400).json({
      success: false,
      message: "note_id is required",
    });
  }
  if (!params?.created_by) {
    return res.status(400).json({
      success: false,
      message: "created_by is required",
    });
  }
  next();
};

export const addComment: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { comment_text, note_id, created_by } = _.merge(req.body, req.params);
  try {
    const data: Partial<IComment> = {
      comment_id: uuidv4(),
      comment: comment_text.toString(),
      note_id,
      user_id: created_by,
    };
    const comment: Partial<IComment> = await CommentModel.create(data);
    req.note = {
      ...req.note.toObject(),
      comments: req.note.comments
        ? [...req.note.comments, comment.toObject().comment_id]
        : [comment.toObject().comment_id],
    };

    console.log("req.note: ", req.note);
    next();
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Comment creation failed." });
  }
};

export const noteExist: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { note_id } = _.merge(req.body, req.params);
  try {
    const note: Partial<INote> = await NoteModel.findOne({ note_id }).exec();
    if (!note) {
      return res.status(400).json({
        success: false,
        message: "note is not exist",
      });
    }
    req.note = note;
    return next();
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Something went wrong",
    });
  }
};

export const updateNoteForComment: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { note_id } = req.note;
  try {
    console.log(req.note.comments);
    await NoteModel.updateOne(
      { note_id },
      { comments: req.note.comments },
      { upsert: true }
    );
    return res.status(200).json({
      success: true,
      message: "Comment added successfully",
      data: req.note,
    });
  } catch (error) {
    return res.status(500).json({ error: "Comment update failed." });
  }
};
export const validateInteractionData: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const params = _.merge(req.body, req.params);
  console.log("params: ", params);
  if (!params?.type) {
    return res.status(400).json({
      success: false,
      message: "type is required",
    });
  }
  if (
    params?.type !== "like" &&
    params?.type !== "dislike" &&
    params?.type !== "neutral"
  ) {
    return res.status(400).json({
      success: false,
      message: "type must be like, neutral or dislike",
    });
  }
  if (!params?.note_id) {
    return res.status(400).json({
      success: false,
      message: "note_id is required",
    });
  }
  if (!params?.created_by) {
    return res.status(400).json({
      success: false,
      message: "created_by is required",
    });
  }
  next();
};

export const addInteraction: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  // if interaction already exist then update interaction
  const { type, note_id, created_by } = _.merge(req.body, req.params);

  try {
    if (type == "neutral") {
      console.log("req.note.interactions: ", req.note.interactions);

      // Update is_delete to true where created_by and note_id
      const interaction = await InteractionModel.findOneAndUpdate(
        { note_id, user_id: created_by, is_delete: false },
        { is_delete: true },
      );

      console.log("interaction: ", interaction.interaction_id);
      const updatedInteractions = req.note.interactions.filter(interaction_id => interaction_id != interaction.interaction_id);
      console.log("interaction: ", updatedInteractions);

      await NoteModel.updateOne(
        { note_id },
        { interactions: updatedInteractions },
      );

      return res.status(200).json({
        success: true,
        message: "Interaction added successfully",
        data: req.note,
      });
    }
    const data: Partial<IInteraction> = {
      interaction_id: uuidv4(),
      type,
      note_id,
      user_id: created_by,
    };

    let interaction: Partial<IInteraction> = await InteractionModel.findOne({
      note_id,
      user_id: created_by,
      is_delete: false,
    }).exec();

    if (interaction)
      interaction = (
        await InteractionModel.findOneAndUpdate(
          { interaction_id: interaction.interaction_id, is_delete: false },
          { type }
        )
      ).toObject();
    else {
      interaction = await InteractionModel.create(data);

      req.note = {
        ...req.note.toObject(),
        interactions: req.note.interactions
          ? [...req.note.interactions, interaction.toObject().interaction_id]
          : [interaction.toObject().interaction_id],
      };
    }
    next();
  } catch (error) {
    console.log(error);
    return res.status(500).json({ error: "Interaction creation failed." });
  }
};

export const updateNoteForInteraction: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { note_id } = req.note;
  try {
    await NoteModel.updateOne(
      { note_id },
      { interactions: req.note.interactions },
      { upsert: true }
    );
    return res.status(200).json({
      success: true,
      message: "Interaction added successfully",
      data: req.note,
    });
  } catch (error) {
    return res.status(500).json({ error: "Interaction update failed." });
  }
};
