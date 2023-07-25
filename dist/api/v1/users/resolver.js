"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const model_1 = __importDefault(require("./model"));
const userResolver = {
    Query: {
        getUser: async (parent, args, context, info) => {
            const { uid } = args;
            console.log(args);
            try {
                const user = await model_1.default.findOne({ uid });
                return user;
            }
            catch (err) {
                return err;
            }
        },
    },
};
exports.default = userResolver;
