import { Router } from 'express';
import * as services from './services';
const user: Router = Router();

user.post('/register', [
    services.ValidateUserCreateData,
    services.ValidateUserExists,
    services.createUser,
]);

user.get('/get-user', [
    services.ValidateUserExists,
    
])

export default user;