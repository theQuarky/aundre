"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// combine resolves from all modules
const lodash_1 = require("lodash");
const resolver_1 = __importDefault(require("./users/resolver"));
const resolvers = (0, lodash_1.merge)({ ...resolver_1.default });
exports.default = resolvers;
