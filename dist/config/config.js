"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv = __importStar(require("dotenv"));
dotenv.config();
exports.default = {
    APP: process.env.APP || 'development',
    PORT: process.env.PORT || '3000',
    DB_DIALECT: process.env.DB_DIALECT || 'mongo',
    DB_HOST: process.env.DB_HOST || 'mongodb+srv://ranahiren27:svFZX1T7XqGhNPrl@cluster0.oh1eye5.mongodb.net/dev',
    DB_NAME: process.env.DB_NAME || 'example_db',
    DB_PASSWORD: process.env.DB_PASSWORD || 'db-password',
    DB_PORT: process.env.DB_PORT || '27017',
    DB_USER: process.env.DB_USER || 'root',
    JWT_ENCRYPTION: process.env.JWT_ENCRYPTION || 'jwt_please_change',
    JWT_EXPIRATION: process.env.JWT_EXPIRATION || '1h',
    SALT_ROUNDS: process.env.SALT_ROUNDS || 10
};
