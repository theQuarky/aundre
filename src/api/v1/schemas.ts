// combine all schemas from all modules

import { merge } from "lodash";
import userSchema from "./users/schema";

const schemas = merge(userSchema);
export default schemas;
