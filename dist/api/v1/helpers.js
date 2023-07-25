"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.extractHashtags = exports.isValidFirebaseAudioUrl = void 0;
const node_fetch_1 = __importDefault(require("node-fetch")); // Assuming you have 'node-fetch' installed for making HTTP requests
const isValidFirebaseAudioUrl = (url) => {
    return true;
    try {
        const urlObj = new URL(url);
        // Check if the URL domain is from Firebase Storage
        if (!urlObj.hostname.endsWith("firebasestorage.googleapis.com")) {
            return false;
        }
        // Perform an HTTP HEAD request to check the Content-Type header
        return (0, node_fetch_1.default)(url, { method: "HEAD" })
            .then((response) => {
            if (!response.ok) {
                return false;
            }
            const contentType = response.headers.get("content-type");
            return contentType && contentType.startsWith("audio/");
        })
            .catch(() => false);
    }
    catch (error) {
        return false;
    }
};
exports.isValidFirebaseAudioUrl = isValidFirebaseAudioUrl;
const extractHashtags = (caption) => {
    // Extract hashtags using a regular expression
    return caption.match(/#[a-zA-Z0-9_]+/g) || [];
};
exports.extractHashtags = extractHashtags;
