import { buildSchema } from "graphql"

export default buildSchema(`
  type User {
    _id: ID
    username: String
    name: String
    gender: String
    email: String
    uid: String
    profile_pic: String
    dob: String
    intro: String
    following: [String]
    followers: [String]
    requests: [String]
    pending_requests: [String]
    is_delete: Boolean
    created_at: String
    updated_at: String
  }

  type Query {
    getUser(uid: String): User
  }
`);
