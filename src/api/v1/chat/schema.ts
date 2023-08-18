import { buildSchema } from "graphql";

export default buildSchema(`

  type User {
    uid: String!
    username: String!
    profile_pic: String!
  }

  type Message {
    message_id: String!
    chat_id: String!
    sender_id: String!
    partner_id: String!
    message: String!
    sender: User!
    created_at: String!
  }

  type Partner {
    uid: String!
    username: String!
    profile_pic: String!
  }

  type Chat {
    chat_id: String!
    partner_id: String!
    partner: Partner!
    last_message: String!
    last_message_time: String!
  }

  type Query {
    getMessages(uid: String!, page: Int!): [Message!]
    getChats(uid: String!): [Chat!]
  }
`);
