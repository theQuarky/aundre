import { Document } from "mongoose";

export default interface IUser extends Document {
  username: string;
  name: string;
  email: string;
  uid: string;
  gender?: string;
  profile_pic?: string;
  dob: Date;
  intro?: string;
  following?: string[];
  followers?: string[];
  requests?: string[];
  pending_requests?: string[];
  notes?: string[];
  is_private?: boolean;
  is_delete?: boolean;
  created_at: Date;
  updated_at: Date;
}
