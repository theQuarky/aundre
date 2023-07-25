"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// combine resolves from all modules
const merge_1 = require("@graphql-tools/merge");
const resolver_1 = __importDefault(require("./users/resolver"));
const resolver_2 = __importDefault(require("./notes/resolver"));
exports.default = (0, merge_1.mergeResolvers)([resolver_1.default, resolver_2.default]);
