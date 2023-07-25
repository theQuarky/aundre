"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// combine all schemas from all modules
const schema_1 = require("@graphql-tools/schema");
const merge_1 = require("@graphql-tools/merge");
const schema_2 = __importDefault(require("./users/schema"));
const schema_3 = __importDefault(require("./notes/schema"));
exports.default = (0, schema_1.makeExecutableSchema)({
    typeDefs: (0, merge_1.mergeTypeDefs)([schema_2.default, schema_3.default]),
});
