"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const graphql_1 = require("graphql");
exports.default = (0, graphql_1.buildSchema)(`
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
    notes: [String]
    is_delete: Boolean
    created_at: String
    updated_at: String
  }

  type Query {
    getUser(uid: String): User
  }
`);