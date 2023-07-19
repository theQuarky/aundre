#!/bin/bash

# Function to create the module structure
create_module() {
  module_name="$1"

  if [ -d "./src/api/v1/$module_name" ]; then
    echo "Module '$module_name' already exists."
    exit 1
  fi

  echo "Creating module '$module_name'..."

  # Create the module directory
  mkdir -p "./src/api/v1/$module_name"

  # Create the module files
  touch "./src/api/v1/$module_name/I${module_name^}.ts"
  touch "./src/api/v1/$module_name/model.ts"
  touch "./src/api/v1/$module_name/resolver.ts"
  touch "./src/api/v1/$module_name/routes.ts"
  touch "./src/api/v1/$module_name/schema.ts"
  touch "./src/api/v1/$module_name/services.ts"


  # Create the default content for routes.ts
  default_routes_content="import { Router } from \"express\";\n"
  default_routes_content+="import * as services from \"./services\";\n"
  default_routes_content+="const $module_name_first_uppercase: Router = Router();\n"
  default_routes_content+="$module_name_first_uppercase.post('/test-route', [\n"
  default_routes_content+="  (req, res) => {\n"
  default_routes_content+="    return res.send(\"Test $module_name_first_uppercase\");\n"
  default_routes_content+="  }\n"
  default_routes_content+="]);"

  echo -e "$default_routes_content" > "./src/api/v1/$module_name/routes.ts"

  # Create the default content for services.ts
  # import { NextFunction, RequestHandler } from "express";
  # import IRequest from "../IRequest";
  # import IResponse from "../IResponse";
  # import _ from "lodash";

  default_services_content="import { NextFunction, RequestHandler } from \"express\";\n"
  default_services_content+="import IRequest from \"../IRequest\";\n"
  default_services_content+="import IResponse from \"../IResponse\";\n"
  default_services_content+="import _ from \"lodash\";\n"

  echo -e "$default_services_content" > "./src/api/v1/$module_name/services.ts"

  # Create the default content for interface
  # export interface I${module_name^} {
  #  }
  default_interface_content="export interface I${module_name^} {\n\n}\n"
  default_interface_content+="export interface I${module_name^}Input {\n\n}\n"

  echo -e "$default_interface_content" > "./src/api/v1/$module_name/I${module_name^}.ts"

  # Create the default content for model
  # import mongoose, { Schema, Document } from "mongoose";
  # import { I${module_name^} } from "./I${module_name^}";
  # const ${module_name^}Schema: Schema = new Schema({
  # });
  # export default mongoose.model<I${module_name^} & Document>("${module_name^}", ${module_name^}Schema);
  default_model_content="import mongoose, { Schema, Document } from \"mongoose\";\n"
  default_model_content+="import { I${module_name^} } from \"./I${module_name^}\";\n"
  default_model_content+="const ${module_name^}Schema: Schema = new Schema({\n\n});\n"
  default_model_content+="export default mongoose.model<I${module_name^} & Document>(\"${module_name^}\", ${module_name^}Schema);\n"

  echo -e "$default_model_content" > "./src/api/v1/$module_name/model.ts"

  # Create the default content for resolver
  # import { I${module_name^} } from "./I${module_name^}}";
  # import {  } from "./model";

  # const userResolver = {
  #   Query: {
  #     getNoteById: async (parent: any, args: any, context: any, info: any) => {
  #     },
  #   },
  # };


  default_resolver_content="import { I${module_name^} } from \"./I${module_name^}\";\n"
  default_resolver_content+="import ${module_name^} from \"./model\";\n\n"
  default_resolver_content+="const ${module_name}Resolver = {\n"
  default_resolver_content+="  Query: {\n"
  default_resolver_content+="    testQuery: async (parent: any, args: any, context: any, info: any) => {\n"
  default_resolver_content+="    },\n"
  default_resolver_content+="  },\n"
  default_resolver_content+="};\n\n"
  default_resolver_content+="export default ${module_name}Resolver;\n"

  echo -e "$default_resolver_content" > "./src/api/v1/$module_name/resolver.ts"

  # Save the default content to routes.ts
  echo -e "$default_routes_content" > "./src/api/v1/$module_name_first_uppercase/routes.ts"

  echo "Module '$module_name' created successfully."
}

# Function to add service in service.ts file
add_service() {
  module_name="$1"
  service_name="$2"
  service_content="export const $service_name: RequestHandler = async (req: IRequest, res: IResponse, next: NextFunction) => {\n\n}\n"

  service_file="./src/api/v1/$module_name/services.ts"

  # If the module directory doesn't exist, create it
  if [ ! -d "./src/api/v1/$module_name" ]; then
    create_module "$module_name"
  fi

  # Append the service content to the service.ts file
  echo -e "$service_content" >> "$service_file"

  echo "Service '$service_name' added to $service_file"
}
# Get the argument passed to the script
argument="$1"

# Use the case statement to check different values of the argument
case "$argument" in
  "module")
    if [ -z "$2" ]
    then
      echo "Module name is required"
      exit 1
    fi

    create_module "$2"
    ;;
  "service")
    if [ -z "$3" ]
    then
      echo "Module name is required"
      exit 1
    fi

    if [ -z "$2" ]
    then
      echo "Service name is required"
      exit 1
    fi

    module_name="$2"
    service_name="$3"

    add_service "$module_name" "$service_name"
    ;;
  *)
    # This part handles any other value of the argument that doesn't match the above cases
    echo "Invalid option. Usage: $0 {module|service|option3}"
    exit 1
    ;;
esac
