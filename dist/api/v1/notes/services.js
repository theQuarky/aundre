"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.returnNote = exports.updateTags = exports.createNote = exports.createTags = exports.processCaption = exports.validateUser = exports.validateMediaUrl = exports.validateCreateData = void 0;
const lodash_1 = __importDefault(require("lodash"));
const model_1 = require("./model");
const uuid_1 = require("uuid");
const helpers_1 = require("../helpers");
const model_2 = __importDefault(require("../users/model"));
// write function to validate and insert note in database use same logic as instagram post creation
// validation middleware
const validateCreateData = async (req, res, next) => {
    const { media_url, created_by } = lodash_1.default.merge(req.body, req.params);
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
exports.validateCreateData = validateCreateData;
const validateMediaUrl = async (req, res, next) => {
    const { media_url } = lodash_1.default.merge(req.body, req.params);
    // write logic to validate media_url is valid url
    if (!(0, helpers_1.isValidFirebaseAudioUrl)(media_url)) {
        return res.status(400).json({
            error: "Invalid media_url. Please provide a valid Firebase Storage URL for audio content.",
        });
    }
    next();
};
exports.validateMediaUrl = validateMediaUrl;
const validateUser = async (req, res, next) => {
    const { created_by } = lodash_1.default.merge(req.body, req.params);
    // write logic to validate user is valid
    try {
        const user = await model_2.default.findOne({
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
    }
    catch (error) {
        res.status(500).json({
            success: false,
            message: "Something went wrong",
        });
    }
};
exports.validateUser = validateUser;
const processCaption = async (req, res, next) => {
    const { caption } = lodash_1.default.merge(req.body, req.params);
    if (!caption) {
        return next();
    }
    const tags = (0, helpers_1.extractHashtags)(caption);
    // other processing for future
    req.note = {
        tags: tags,
    };
    next();
};
exports.processCaption = processCaption;
const createTags = async (req, res, next) => {
    var _a;
    if (!((_a = req === null || req === void 0 ? void 0 : req.note) === null || _a === void 0 ? void 0 : _a.tags)) {
        return next();
    }
    const { tags } = req.note;
    // Function to check if a tag exists in the database and create it if it doesn't
    async function findOrCreateTag(tag) {
        try {
            const existingTag = await model_1.TagModel.findOne({ tag }).exec();
            if (existingTag) {
                return existingTag.tag_id;
            }
            else {
                const newTag = await model_1.TagModel.create({ tag_id: (0, uuid_1.v4)(), tag });
                return newTag.tag_id;
            }
        }
        catch (error) {
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
    }
    catch (error) {
        return res.status(500).json({ error: "Tag creation failed." });
    }
};
exports.createTags = createTags;
const createNote = async (req, res, next) => {
    var _a, _b;
    const { media_url, created_by, caption } = lodash_1.default.merge(req.body, req.params);
    let tags = [];
    if (!((_a = req.note) === null || _a === void 0 ? void 0 : _a.tags)) {
        tags = [];
    }
    else {
        tags = (_b = req === null || req === void 0 ? void 0 : req.note) === null || _b === void 0 ? void 0 : _b.tags;
    }
    try {
        const data = {
            note_id: (0, uuid_1.v4)(),
            media_url,
            created_by,
            caption,
            tags,
        };
        const note = await model_1.NoteModel.create(data);
        req.note = note;
        next();
    }
    catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Note creation failed." });
    }
};
exports.createNote = createNote;
const updateTags = async (req, res, next) => {
    const { tags } = req.note;
    const { note_id } = req.note;
    try {
        await model_1.TagModel.updateMany({ tag_id: { $in: tags } }, { $addToSet: { note_id: note_id } });
        next();
    }
    catch (error) {
        return res.status(500).json({ error: "Tag update failed." });
    }
};
exports.updateTags = updateTags;
const returnNote = async (req, res, next) => {
    const { note } = req;
    res.status(200).json({
        success: true,
        message: "Note created successfully",
        data: note,
    });
};
exports.returnNote = returnNote;
