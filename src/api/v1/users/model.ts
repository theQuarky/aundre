import { Schema, model } from "mongoose";
import IUser from "./IUser";

const UserSchema: Schema<IUser> = new Schema(
  {
    username: { type: String, required: true },
    email: { type: String, required: true },
    uid: { type: String, required: true, indexes: true, unique: true },
    dob: { type: Date , required: true},
    profile_pic: { type: String },
    intro: { type: String },
    is_delete: { type: Boolean, default: false },
  },
  {
    timestamps: {
      createdAt: "created_at",
      updatedAt: "updated_at",
    },
    versionKey: false,
  }
);

const UserModel = model<IUser>("User", UserSchema);

export default UserModel;
