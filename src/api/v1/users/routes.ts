import { Router } from "express";
import * as services from "./services";
const user: Router = Router();

user.post("/register", [
  services.ValidateUserCreateData,
  // services.ValidateUserExists,
  services.createUser,
]);

user.post("/username-available", [services.ValidateUsernameAvailable]);

user.get("/search-users/:name", [services.searchUsers]);
export default user;
