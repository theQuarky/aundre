"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Router = Router();
post('/test-route', [
    (req, res) => {
        return res.send("Test ");
    }
]);
