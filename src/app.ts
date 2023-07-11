import * as bodyParser from "body-parser";
import cors from "cors";
import * as express from "express";
import morgan from "morgan";
import apiV1 from "./api/v1/index";
import * as errorHandler from "./helpers/errorHandler";
import mongoose from "mongoose";
import config from "./config/config";
import { graphqlHTTP } from "express-graphql"; // ES6
import { makeExecutableSchema } from 'graphql-tools';
import schemas from "./api/v1/schemas";
import resolvers from "./api/v1/resolvers";

class App {
  public express: express.Application;

  constructor() {
    this.express = express.default();
    this.setDatabase();
    this.setMiddlewares();
    this.setGraphql();
    this.setRoutes();
    this.catchErrors();
  }

  private setMiddlewares(): void {
    this.express.use(cors());
    this.express.use(morgan("dev"));
    this.express.use(bodyParser.json());
    this.express.use(bodyParser.urlencoded({ extended: false }));
  }

  private setGraphql(): void {
    const schema = makeExecutableSchema({
      typeDefs: schemas,
      resolvers: resolvers,
    });
    this.express.use(
      "/graphql",
      graphqlHTTP({
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
      })
    );
  }

  private setRoutes(): void {
    this.express.use("/v1", apiV1);
  }

  // database connection
  private setDatabase(): void {
    mongoose.connect(config.DB_HOST);
    mongoose.connection.on("connected", () => {
      console.log("Connected to the database");
    });
    mongoose.connection.on("error", (error) => {
      console.log(error);
    });
    mongoose.Promise = global.Promise;
  }

  private catchErrors(): void {
    this.express.use(errorHandler.notFound);
    this.express.use(errorHandler.internalServerError);
  }

  public startServer(port: number): void {
    this.express.listen(port, () => {
      console.log(`Server started on port ${port}`);
    });
  }
}

export default new App();
