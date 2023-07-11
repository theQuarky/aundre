"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.searchUser = exports.getUser = exports.deleteUser = exports.updateUser = exports.createUser = exports.ValidateUserExists = exports.ValidateUserUpdateData = exports.ValidateUserCreateData = void 0;
const lodash_1 = __importDefault(require("lodash"));
const model_1 = __importDefault(require("./model"));
const ValidateUserCreateData = (req, res, next) => {
    const { dob, email, username, uid } = lodash_1.default.merge(req.body, req.params);
    if (!dob || !email || !username || !uid) {
        return res.status(400).send({
            success: false,
            message: "Missing required fields: uid, dob, email",
        });
    }
    next();
};
exports.ValidateUserCreateData = ValidateUserCreateData;
const ValidateUserUpdateData = (req, res, next) => {
    const { email, username, dob } = lodash_1.default.merge(req.body, req.params);
    if (!email || !username || !dob) {
        return res.status(400).send({
            success: false,
            message: "Missing required fields: email, username, dob",
        });
    }
    next();
};
exports.ValidateUserUpdateData = ValidateUserUpdateData;
const ValidateUserExists = async (req, res, next) => {
    const { uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOne({ uid });
        if (user) {
            return res.status(400).send({
                success: false,
                message: "User already exist",
            });
        }
        req.user = user;
        next();
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.ValidateUserExists = ValidateUserExists;
const createUser = async (req, res, next) => {
    const { dob, email, username, uid, profile_pic } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.create({
            dob,
            email,
            username,
            uid,
            profile_pic
        });
        return res.status(200).send({
            success: true,
            message: "User created successfully",
            user,
        });
    }
    catch (err) {
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.createUser = createUser;
const updateUser = async (req, res, next) => {
    const { name, email, password, username, uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findByIdAndUpdate({ uid }, {
            name,
            email,
            password,
            username,
            uid,
        });
        return res.status(200).send({
            success: true,
            message: "User updated successfully",
            user,
        });
    }
    catch (err) {
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.updateUser = updateUser;
const deleteUser = async (req, res, next) => {
    const { uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findByIdAndUpdate({ uid }, {
            is_delete: true,
        });
        return res.status(200).send({
            success: true,
            message: "User deleted successfully",
            user,
        });
    }
    catch (err) {
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.deleteUser = deleteUser;
const getUser = async (req, res, next) => {
    const { uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findById(uid);
        return res.status(200).send({
            success: true,
            message: "User found successfully",
            user,
        });
    }
    catch (err) {
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.getUser = getUser;
const searchUser = async (req, res, next) => {
    const { username } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.find({
            username: { $regex: username, $options: "i" },
        });
        return res.status(200).send({
            success: true,
            message: "User found successfully",
            user,
        });
    }
    catch (err) {
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.searchUser = searchUser;
