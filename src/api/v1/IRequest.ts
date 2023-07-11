import { Request } from "express";
import IUser from "./users/IUser";

export default interface IRequest extends Request {
  success: boolean;
  message: string;
  data?: any;
  user?: IUser | IUser[] | any;
}
