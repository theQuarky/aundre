// combine all schemas from all modules
import { makeExecutableSchema } from "@graphql-tools/schema";
import { mergeTypeDefs } from "@graphql-tools/merge";
import userSchema from "./users/schema";
import noteSchema from "./notes/schema";
import chatSchema from "./chat/schema";

export default makeExecutableSchema({
  typeDefs: mergeTypeDefs([userSchema, noteSchema, chatSchema]),
});
