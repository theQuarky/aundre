import { Router } from 'express';
import users from './users/routes';

const router: Router = Router();

router.use('/users', users);

export default router;