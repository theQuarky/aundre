import { Document } from "mongoose";

export default interface IUser extends Document {
  username: string;
  email: string;
  uid: string;
  profile_pic?: string;
  dob: Date;
  intro?: string;
  is_delete?: boolean;
  created_at: Date;
  updated_at: Date;
}
