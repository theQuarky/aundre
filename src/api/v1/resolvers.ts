// combine resolves from all modules
import { mergeResolvers } from "@graphql-tools/merge";
import userResolvers from "./users/resolver";
import noteResolvers from "./notes/resolver";

export default mergeResolvers([userResolvers, noteResolvers]);
