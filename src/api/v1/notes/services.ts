import { NextFunction, RequestHandler } from "express";
import IRequest from "../IRequest";
import IResponse from "../IResponse";
import _ from "lodash";
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
