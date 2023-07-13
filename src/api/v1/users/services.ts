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
  const data = _.merge(
    req.body,
    req.params
  );
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
    let user:IUser = await UserModal.findOne({ uid: userData.uid });

    if (user) {
      user = await UserModal.findByIdAndUpdate( user._id, userData);
    }else{
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
  const data = _.merge(
    req.body,
    req.params
  );
  const userData = {
    dob: data.dob,
    email: data.email,
    username: data.username,
    name: data.name,
    uid: data.uid,
    profile_pic: data.profile_pic,
    intro: data.intro,
    gender:data.gender
  };
  try {
    const user = await UserModal.findByIdAndUpdate(
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
    const user = await UserModal.findByIdAndUpdate(
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

export const searchUser: RequestHandler = async (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { username } = _.merge(req.body, req.params);
  try {
    const user = await UserModal.find({
      username: { $regex: username, $options: "i" },
    });

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
  const { name } = _.merge(req.body, req.params);
  try {
    const users = await UserModal.find({
      username: { $regex: name, $options: "i" },
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
