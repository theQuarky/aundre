"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.addNote = exports.cancelFollowRequest = exports.unfollowUser = exports.rejectFollowRequest = exports.acceptFollowRequest = exports.followPrivateUser = exports.followPublicUser = exports.getUserType = exports.followUserExists = exports.searchUsers = exports.ValidateUsernameAvailable = exports.getUser = exports.deleteUser = exports.updateUser = exports.createUser = exports.ValidateUserExists = exports.ValidateUserUpdateData = exports.ValidateUserCreateData = void 0;
const lodash_1 = __importDefault(require("lodash"));
const model_1 = __importDefault(require("./model"));
const ValidateUserCreateData = (req, res, next) => {
    const { name, dob, email, username, uid } = lodash_1.default.merge(req.body, req.params);
    if (!name || !dob || !email || !username || !uid) {
        return res.status(400).send({
            success: false,
            message: "Missing required fields: uid, dob, email",
        });
    }
    next();
};
exports.ValidateUserCreateData = ValidateUserCreateData;
const ValidateUserUpdateData = (req, res, next) => {
    const { name, email, username, dob } = lodash_1.default.merge(req.body, req.params);
    if (!name || !email || !username || !dob) {
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
    const data = lodash_1.default.merge(req.body, req.params);
    const userData = {
        dob: data.dob,
        email: data.email,
        username: data.username,
        name: data.name,
        uid: data.uid,
        profile_pic: data.profile_pic,
        intro: data.intro,
        gender: data.gender,
    };
    try {
        let user = await model_1.default.findOne({ uid: userData.uid });
        if (user) {
            user = await model_1.default.findOneAndUpdate({ uid: user.uid }, userData);
        }
        else {
            user = await model_1.default.create(userData);
        }
        return res.status(200).send({
            success: true,
            message: "User created successfully",
            user,
        });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.createUser = createUser;
const updateUser = async (req, res, next) => {
    const data = lodash_1.default.merge(req.body, req.params);
    const userData = {
        dob: data.dob,
        email: data.email,
        username: data.username,
        name: data.name,
        uid: data.uid,
        profile_pic: data.profile_pic,
        intro: data.intro,
        gender: data.gender,
    };
    try {
        const user = await model_1.default.findOneAndUpdate({ uid: userData.uid }, userData);
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
        const user = await model_1.default.findOneAndUpdate({ uid }, {
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
// export const searchUser: RequestHandler = async (
//   req: IRequest,
//   res: IResponse,
//   next: NextFunction
// ) => {
//   const { username,uid } = _.merge(req.body, req.params);
//   try {
//     const user = await UserModal.find({
//       name: { $regex: new RegExp(username, "i") },
//       username: { $regex: new RegExp(username, "i") },
//       uid: { $ne: uid },
//     });
//     return res.status(200).send({
//       success: true,
//       message: "User found successfully",
//       user,
//     });
//   } catch (err) {
//     return res.status(500).send({
//       success: false,
//       message: "Internal Server Error",
//     });
//   }
// };
const ValidateUsernameAvailable = async (req, res, next) => {
    const { username, uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOne({ username, uid: { $ne: uid } });
        if (user) {
            return res.status(200).send({
                success: false,
                message: "Username already exist",
            });
        }
        else {
            return res.status(200).send({
                success: true,
                message: "Username available",
            });
        }
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.ValidateUsernameAvailable = ValidateUsernameAvailable;
const searchUsers = async (req, res, next) => {
    const { name, uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const users = await model_1.default.find({
            $or: [
                {
                    username: { $regex: name, $options: "i" },
                },
                { name: { $regex: name, $options: "i" } },
            ],
            uid: { $ne: uid },
        });
        return res.status(200).send({
            success: true,
            message: "User found successfully",
            users,
        });
    }
    catch (err) {
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.searchUsers = searchUsers;
const followUserExists = async (req, res, next) => {
    const { follow_uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOne({ uid: follow_uid });
        if (user) {
            return next();
        }
        return res.status(200).send({
            success: false,
            message: "User not found",
        });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.followUserExists = followUserExists;
const getUserType = async (req, res, next) => {
    const { follow_uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOne({ uid: follow_uid });
        console.log(user);
        req.data = {};
        if (user.is_private) {
            req.data.isFollowingPrivateUser = true;
        }
        else {
            req.data.isFollowingPrivateUser = false;
        }
        return next();
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.getUserType = getUserType;
const followPublicUser = async (req, res, next) => {
    console.log("Follow public user: ", req.data.isFollowingPrivateUser);
    if (req.data.isFollowingPrivateUser) {
        return next();
    }
    const { uid, follow_uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOneAndUpdate({ uid: uid }, {
            $addToSet: {
                following: follow_uid,
            },
        }, { new: true });
        const followUser = await model_1.default.findOneAndUpdate({ uid: follow_uid }, {
            $addToSet: {
                followers: uid,
            },
        }, { new: true });
        return res.status(200).send({
            success: true,
            message: "User followed successfully",
            user,
            followUser,
        });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.followPublicUser = followPublicUser;
const followPrivateUser = async (req, res, next) => {
    console.log("Follow private user: ", req.data.isFollowingPrivateUser);
    if (req.data.isFollowingPrivateUser === false) {
        return next();
    }
    const { uid, follow_uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOneAndUpdate({ uid: uid }, {
            $addToSet: {
                pending_requests: follow_uid,
            },
        }, { new: true });
        const followUser = await model_1.default.findOneAndUpdate({ uid: follow_uid }, {
            $addToSet: {
                requests: uid,
            },
        }, { new: true });
        return res.status(200).send({
            success: true,
            message: "Request sent successfully",
            user,
            followUser,
        });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.followPrivateUser = followPrivateUser;
const acceptFollowRequest = async (req, res, next) => {
    const { uid, follow_uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOneAndUpdate({ uid: uid }, {
            $addToSet: {
                followers: follow_uid,
            },
            $pull: {
                requests: follow_uid,
            },
        }, { new: true });
        const followUser = await model_1.default.findOneAndUpdate({ uid: follow_uid }, {
            $addToSet: {
                following: uid,
            },
            $pull: {
                pending_requests: uid,
            },
        }, { new: true });
        return res.status(200).send({
            success: true,
            message: "User followed successfully",
            user,
            followUser,
        });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.acceptFollowRequest = acceptFollowRequest;
const rejectFollowRequest = async (req, res, next) => {
    const { uid, follow_uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOneAndUpdate({ uid: uid }, {
            $pull: {
                requests: follow_uid,
            },
        }, { new: true });
        const followUser = await model_1.default.findOneAndUpdate({ uid: follow_uid }, {
            $pull: {
                pending_requests: uid,
            },
        }, { new: true });
        return res.status(200).send({
            success: true,
            message: "User followed successfully",
            user,
            followUser,
        });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.rejectFollowRequest = rejectFollowRequest;
const unfollowUser = async (req, res, next) => {
    const { uid, follow_uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOneAndUpdate({ uid: uid }, {
            $pull: {
                following: follow_uid,
            },
        }, { new: true });
        const followUser = await model_1.default.findOneAndUpdate({ uid: follow_uid }, {
            $pull: {
                followers: uid,
            },
        }, { new: true });
        return res.status(200).send({
            success: true,
            message: "User unfollowed successfully",
            user,
            followUser,
        });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.unfollowUser = unfollowUser;
const cancelFollowRequest = async (req, res, next) => {
    const { uid, follow_uid } = lodash_1.default.merge(req.body, req.params);
    try {
        const user = await model_1.default.findOneAndUpdate({ uid: uid }, {
            $pull: {
                pending_requests: follow_uid,
            },
        }, { new: true });
        const followUser = await model_1.default.findOneAndUpdate({ uid: follow_uid }, {
            $pull: {
                requests: uid,
            },
        }, { new: true });
        return res.status(200).send({
            success: true,
            message: "User unfollowed successfully",
            user,
            followUser,
        });
    }
    catch (err) {
        console.log(err);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.cancelFollowRequest = cancelFollowRequest;
const addNote = async (req, res, next) => {
    try {
        const note = req.note;
        const user = req.user;
        await model_1.default.findOneAndUpdate({ uid: user.uid }, {
            $addToSet: {
                notes: note.note_id,
            },
        });
        return next();
    }
    catch (error) {
        console.log(error);
        return res.status(500).send({
            success: false,
            message: "Internal Server Error",
        });
    }
};
exports.addNote = addNote;
