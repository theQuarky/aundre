import { Router } from "express";
import * as services from "./services";
import * as userServices from "../users/services";
const notes: Router = Router();

notes.post("/create-note", [
  services.validateCreateData,
  services.validateMediaUrl,
  services.validateUser,
  services.processCaption,
  services.createTags,
  services.createNote,
  userServices.addNote,
  services.returnNote,
]);

notes.post("/add-comment", [
  services.validateCommentData,
  services.validateUser,
  services.noteExist,
  services.addComment,
  services.updateNoteForComment,
]);

notes.post("/add-interaction", [
  services.validateInteractionData,
  services.validateUser,
  services.noteExist,
  services.addInteraction,
  services.updateNoteForInteraction,
]);

export default notes;
