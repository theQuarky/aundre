import { Router } from "express";
import * as services from "./services";
const : Router = Router();
.post('/test-route', [
  (req, res) => {
    return res.send("Test ");
  }
]);
