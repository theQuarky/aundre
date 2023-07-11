import { Response } from "express";
import IUser from "./users/IUser";

export default interface IResponse extends Response {
  success: boolean;
  message: string;
  data?: any;
  user?: IUser | IUser[] | any;
}
