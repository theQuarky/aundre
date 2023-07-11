"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const UserSchema = new mongoose_1.Schema({
    username: { type: String, required: true },
    email: { type: String, required: true },
    uid: { type: String, required: true, indexes: true, unique: true },
    dob: { type: Date, required: true },
    profile_pic: { type: String },
    intro: { type: String },
    is_delete: { type: Boolean, default: false },
}, {
    timestamps: {
        createdAt: "created_at",
        updatedAt: "updated_at",
    },
    versionKey: false,
});
const UserModel = (0, mongoose_1.model)("User", UserSchema);
exports.default = UserModel;
