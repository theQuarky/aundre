import { Schema, Document, Model, model } from "mongoose";

// Define the Message interface
export interface IMessage extends Document {
  message_id: string;
  chat_id: string;
  sender: string;
  receiver: string;
  message: string;
  is_delete: boolean;
  is_read: boolean;
  media?: string;
  created_at: Date;
  updated_at: Date;
}

// Define the Chat interface
export interface IChat extends Document {
  chat_id: string;
  messages: IMessage[];
  created_at: Date;
  updated_at: Date;
}
