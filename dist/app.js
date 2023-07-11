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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const bodyParser = __importStar(require("body-parser"));
const cors_1 = __importDefault(require("cors"));
const express = __importStar(require("express"));
const morgan_1 = __importDefault(require("morgan"));
const index_1 = __importDefault(require("./api/v1/index"));
const errorHandler = __importStar(require("./helpers/errorHandler"));
const mongoose_1 = __importDefault(require("mongoose"));
const config_1 = __importDefault(require("./config/config"));
const express_graphql_1 = require("express-graphql"); // ES6
const graphql_tools_1 = require("graphql-tools");
const schemas_1 = __importDefault(require("./api/v1/schemas"));
const resolvers_1 = __importDefault(require("./api/v1/resolvers"));
class App {
    constructor() {
        this.express = express.default();
        this.setDatabase();
        this.setMiddlewares();
        this.setGraphql();
        this.setRoutes();
        this.catchErrors();
    }
    setMiddlewares() {
        this.express.use((0, cors_1.default)());
        this.express.use((0, morgan_1.default)("dev"));
        this.express.use(bodyParser.json());
        this.express.use(bodyParser.urlencoded({ extended: false }));
    }
    setGraphql() {
        const schema = (0, graphql_tools_1.makeExecutableSchema)({
            typeDefs: schemas_1.default,
            resolvers: resolvers_1.default,
        });
        this.express.use("/graphql", (0, express_graphql_1.graphqlHTTP)({
            schema: schema,
            context: ({ event, context }) => {
                console.log("event", event);
                console.log("context", context);
                return {
                    headers: event.headers,
                    functionName: context.functionName,
                    event,
                    context,
                };
            },
            graphiql: true,
        }));
    }
    setRoutes() {
        this.express.use("/v1", index_1.default);
    }
    // database connection
    setDatabase() {
        mongoose_1.default.connect(config_1.default.DB_HOST);
        mongoose_1.default.connection.on("connected", () => {
            console.log("Connected to the database");
        });
        mongoose_1.default.connection.on("error", (error) => {
            console.log(error);
        });
        mongoose_1.default.Promise = global.Promise;
    }
    catchErrors() {
        this.express.use(errorHandler.notFound);
        this.express.use(errorHandler.internalServerError);
    }
    startServer(port) {
        this.express.listen(port, () => {
            console.log(`Server started on port ${port}`);
        });
    }
}
exports.default = new App();
