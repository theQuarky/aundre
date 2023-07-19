import { Request } from "express";
import IUser from "./users/IUser";
import { INote } from "./notes/INote";

export default interface IRequest extends Request {
  success: boolean;
  message: string;
  data?: any;
  user?: IUser | IUser[] | any;
  note?: INote | INote[] | any;
}
