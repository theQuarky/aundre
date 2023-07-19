import { buildSchema } from "graphql";

export default buildSchema(`
    type Note {
      note_id: String!
      media_url: String!
      caption: String!
      tags: [String!]!
      interactions: [String!]!
      like_count: Int
      dislike_count: Int
      comment_count: Int
      comments: [Comment!]
      is_private: Boolean
      is_delete: Boolean
      created_at: String
      updated_at: String
    }

    type Interaction {
      interaction_id: String!
      note_id: String!
      user_id: String!
      type: String!
      is_delete: Boolean
      created_at: String
      updated_at: String
    }

    type Comment {
      comment_id: String!
      note_id: String!
      user_id: String!
      comment: String!
      is_delete: Boolean
      created_at: String
      updated_at: String
    }

    type Tag {
      tag_id: String!
      tag: String!
      note_id: [String!]
    }

    type Query {
      getNoteById(note_id: String!): Note
    }
`);
