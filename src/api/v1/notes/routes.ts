import { Router } from "express";
import * as services from "./services";
import * as userServices from "../users/services";
const notes: Router = Router();

notes.post('/create-note', [
    services.validateCreateData,
    services.validateMediaUrl,
    services.validateUser,
    services.processCaption,
    services.createTags,
    services.createNote,
    userServices.addNote,
    services.returnNote
]);

export default notes;