import { Router } from "express";
import * as services from "./services";
const user: Router = Router();

user.post("/register", [
  services.ValidateUserCreateData,
  // services.ValidateUserExists,
  services.createUser,
]);

user.post("/username-available", [services.ValidateUsernameAvailable]);

user.post("/search-users/:name", [services.searchUsers]);

user.post("/follow-user", [
  services.followUserExists,
  services.getUserType,
  services.followPublicUser,
  services.followPrivateUser
]);

user.post("/unfollow-user", [
  services.unfollowUser
]);

user.post("/cancel-follow-request", [
  services.cancelFollowRequest
]);

user.post("/accept-follow-request", [
  services.acceptFollowRequest
]);

user.post("/reject-follow-request", [
  services.rejectFollowRequest
]);


export default user;
