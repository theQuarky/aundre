// combine resolves from all modules
import { merge } from "lodash";
import userResolvers from "./users/resolver";

const resolvers = merge({...userResolvers});
export default resolvers;
