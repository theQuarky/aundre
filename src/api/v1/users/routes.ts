import { Router } from 'express';
import * as services from './services';
const user: Router = Router();

user.post('/username-available', [
    services.ValidateUsernameAvailable,
]);
user.post('/register', [
    services.ValidateUserCreateData,
    services.ValidateUserExists,
    services.createUser,
]);


export default user;