import { Document } from "mongoose";

interface INote extends Document {
  note_id: string;
  media_url: string;
  caption: string;
  tags: string[];
  interactions?: string[] | IInteraction[];
  comments?: string[] | IComment[];
  is_private?: boolean;
  created_by: string;
  is_delete?: boolean;
  created_at?: Date;
  updated_at?: Date;
  meta?: any;
}

interface IInteraction extends Document {
  interaction_id: string;
  note_id: string;
  user_id: string;
  type: string;
  is_delete?: boolean;
  created_at?: Date;
  updated_at?: Date;
}

interface IComment extends Document {
  comment_id: string;
  note_id: string;
  user_id: string;
  comment: string;
  is_delete?: boolean;
  created_at?: Date;
  updated_at?: Date;
}

interface ITag extends Document {
  tag_id: string;
  tag: string;
  note_id: string[];
}

export { INote, IInteraction, IComment, ITag };
