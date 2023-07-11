import { NextFunction, RequestHandler } from "express";
import IRequest from "../IRequest";
import IResponse from "../IResponse";
import _ from "lodash";
import UserModal from "./model";

export const ValidateUserCreateData: RequestHandler = (
  req: IRequest,
  res: IResponse,
  next: NextFunction
) => {
  const { dob, email, username, uid } = _.merge(req.body, req.params);

  if (!dob || !email || !username || !uid) {
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
  const { email, username, dob } = _.merge(req.body, req.params);

  if (!email || !username || !dob) {
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
  const { dob, email, username, uid, profile_pic } = _.merge(req.body, req.params);

  try {
    const user = await UserModal.create({
      dob,
      email,
      username,
      uid,
      profile_pic
    });

    return res.status(200).send({
      success: true,
      message: "User created successfully",
      user,
    });
  } catch (err) {
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
  const { name, email, password, username, uid } = _.merge(
    req.body,
    req.params
  );

  try {
    const user = await UserModal.findByIdAndUpdate(
      { uid },
      {
        name,
        email,
        password,
        username,
        uid,
      }
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
