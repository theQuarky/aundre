import { buildSchema } from "graphql";

export default buildSchema(`
    type Note {
      note_id: String!
      media_url: String!
      caption: String!
      tags: [String!]!
      interactions: [Interaction!]!
      like_count: Int
      dislike_count: Int
      comment_count: Int
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

    type User {
      username: String!
      uid: String!
      profile_pic: String
    }

    type NoteComments {
      comment_id: String!
      note_id: String!
      user_id: String!
      comment: String!
      created_at: String
      updated_at: String
      user: User
    }

    type Query {
      getNoteById(note_id: String!): Note
      getNoteComments(note_id: String!): [NoteComments]
      getFeed(uid: String!, page: Int) : [Note]
    }  
`);
