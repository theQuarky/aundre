"use strict";
// combine all schemas from all modules
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = require("lodash");
const schema_1 = __importDefault(require("./users/schema"));
const schemas = (0, lodash_1.merge)(schema_1.default);
exports.default = schemas;
