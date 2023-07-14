import { NextFunction, RequestHandler } from "express";
import IRequest from "../IRequest";
import IResponse from "../IResponse";
import _ from "lodash";
import UserModal from "./model";
import IUser from "./IUser";

export const ValidateUserCreateData: RequestHandler = (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { name, dob, email, username, uid } = _.merge(req.body, req.params);

  if (!name || !dob || !email || !username || !uid) {
    return res.status(400).send({
      success: false,
      message: "Missing required fields: uid, dob, email",
    });
  }

  next();
};

export const ValidateUserUpdateData: RequestHandler = (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { name, email, username, dob } = _.merge(req.body, req.params);

  if (!name || !email || !username || !dob) {
    return res.status(400).send({
      success: false,
      message: "Missing required fields: email, username, dob",
    });
  }

  next();
};

export const ValidateUserExists: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { uid } = _.merge(req.body, req.params);

  try {
    const user = await UserModal.findOne({ uid });
    if (user) {
      return res.status(400).send({
        success: false,
        message: "User already exist",
      });
    }

    req.user = user;
    next();
  } catch (err) {
    console.log(err);
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const createUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const data = _.merge(req.body, req.params);
  const userData: Partial<IUser> = {
    dob: data.dob,
    email: data.email,
    username: data.username,
    name: data.name,
    uid: data.uid,
    profile_pic: data.profile_pic,
    intro: data.intro,
    gender: data.gender,
  };

  try {
    let user: IUser = await UserModal.findOne({ uid: userData.uid });

    if (user) {
      user = await UserModal.findOneAndUpdate(user._id, userData);
    } else {
      user = await UserModal.create(userData);
    }

    return res.status(200).send({
      success: true,
      message: "User created successfully",
      user,
    });
  } catch (err) {
    console.log(err);
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const updateUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const data = _.merge(req.body, req.params);
  const userData = {
    dob: data.dob,
    email: data.email,
    username: data.username,
    name: data.name,
    uid: data.uid,
    profile_pic: data.profile_pic,
    intro: data.intro,
    gender: data.gender,
  };
  try {
    const user = await UserModal.findOneAndUpdate(
      { uid: userData.uid },
      userData
    );

    return res.status(200).send({
      success: true,
      message: "User updated successfully",
      user,
    });
  } catch (err) {
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const deleteUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOneAndUpdate(
      { uid },
      {
        is_delete: true,
      }
    );

    return res.status(200).send({
      success: true,
      message: "User deleted successfully",
      user,
    });
  } catch (err) {
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const getUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findById(uid);

    return res.status(200).send({
      success: true,
      message: "User found successfully",
      user,
    });
  } catch (err) {
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

// export const searchUser: RequestHandler = async (
//   req: IRequest,
//   res: IResponse,
//   next: NextFunction
// ) => {
//   const { username,uid } = _.merge(req.body, req.params);
//   try {
//     const user = await UserModal.find({
//       name: { $regex: new RegExp(username, "i") },
//       username: { $regex: new RegExp(username, "i") },
//       uid: { $ne: uid },
//     });

//     return res.status(200).send({
//       success: true,
//       message: "User found successfully",
//       user,
//     });
//   } catch (err) {
//     return res.status(500).send({
//       success: false,
//       message: "Internal Server Error",
//     });
//   }
// };

export const ValidateUsernameAvailable: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { username, uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOne({ username, uid: { $ne: uid } });
    if (user) {
      return res.status(200).send({
        success: false,
        message: "Username already exist",
      });
    } else {
      return res.status(200).send({
        success: true,
        message: "Username available",
      });
    }
  } catch (err) {
    console.log(err);
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const searchUsers: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { name, uid } = _.merge(req.body, req.params);
  try {
    const users = await UserModal.find({
      $or: [
        {
          username: { $regex: name, $options: "i" },
        },
        { name: { $regex: name, $options: "i" } },
      ],
      uid: { $ne: uid },
    });

    return res.status(200).send({
      success: true,
      message: "User found successfully",
      users,
    });
  } catch (err) {
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const followUserExists: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { follow_uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOne({ uid: follow_uid });
    if (user) {
      return next();
    }

    return res.status(200).send({
      success: false,
      message: "User not found",
    });
  } catch (err) {
    console.log(err);
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const getUserType: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { follow_uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOne({ uid: follow_uid });
    console.log(user);
    req.data = {};
    if (user.is_private) {
      req.data.isFollowingPrivateUser = true;
    } else {
      req.data.isFollowingPrivateUser = false;
    }
    return next();
  } catch (err) {
    console.log(err);
    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const followPublicUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  console.log("Follow public user: ", req.data.isFollowingPrivateUser);
  if (req.data.isFollowingPrivateUser) {
    return next();
  }

  const { uid, follow_uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOneAndUpdate(
      { uid: uid },
      {
        $addToSet: {
          following: follow_uid,
        },
      },
      { new: true }
    );
    const followUser = await UserModal.findOneAndUpdate(
      { uid: follow_uid },
      {
        $addToSet: {
          followers: uid,
        },
      },
      { new: true }
    );

    return res.status(200).send({
      success: true,
      message: "User followed successfully",
      user,
      followUser,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const followPrivateUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  console.log("Follow private user: ", req.data.isFollowingPrivateUser);
  if (req.data.isFollowingPrivateUser === false) {
    return next();
  }

  const { uid, follow_uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOneAndUpdate(
      { uid: uid },
      {
        $addToSet: {
          pending_requests: follow_uid,
        },
      },
      { new: true }
    );
    const followUser = await UserModal.findOneAndUpdate(
      { uid: follow_uid },
      {
        $addToSet: {
          requests: uid,
        },
      },
      { new: true }
    );

    return res.status(200).send({
      success: true,
      message: "Request sent successfully",
      user,
      followUser,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const acceptFollowRequest: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { uid, follow_uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOneAndUpdate(
      { uid: uid },
      {
        $addToSet: {
          followers: follow_uid,
        },
        $pull: {
          requests: follow_uid,
        },
      },
      { new: true }
    );
    const followUser = await UserModal.findOneAndUpdate(
      { uid: follow_uid },
      {
        $addToSet: {
          following: uid,
        },
        $pull: {
          pending_requests: uid,
        },
      },
      { new: true }
    );

    return res.status(200).send({
      success: true,
      message: "User followed successfully",
      user,
      followUser,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const rejectFollowRequest: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { uid, follow_uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOneAndUpdate(
      { uid: uid },
      {
        $pull: {
          requests: follow_uid,
        },
      },
      { new: true }
    );
    const followUser = await UserModal.findOneAndUpdate(
      { uid: follow_uid },
      {
        $pull: {
          pending_requests: uid,
        },
      },
      { new: true }
    );

    return res.status(200).send({
      success: true,
      message: "User followed successfully",
      user,
      followUser,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const unfollowUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { uid, follow_uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOneAndUpdate(
      { uid: uid },
      {
        $pull: {
          following: follow_uid,
        },
      },
      { new: true }
    );
    const followUser = await UserModal.findOneAndUpdate(
      { uid: follow_uid },
      {
        $pull: {
          followers: uid,
        },
      },
      { new: true }
    );

    return res.status(200).send({
      success: true,
      message: "User unfollowed successfully",
      user,
      followUser,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const cancelFollowRequest: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { uid, follow_uid } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.findOneAndUpdate(
      { uid: uid },
      {
        $pull: {
          pending_requests: follow_uid,
        },
      },
      { new: true }
    );
    const followUser = await UserModal.findOneAndUpdate(
      { uid: follow_uid },
      {
        $pull: {
          requests: uid,
        },
      },
      { new: true }
    );

    return res.status(200).send({
      success: true,
      message: "User unfollowed successfully",
      user,
      followUser,
    });
  } catch (err) {
    console.log(err);

    return res.status(500).send({
      success: false,
      message: "Internal Server Error",
    });
  }
};
