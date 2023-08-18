import { Router } from 'express';
import users from './users/routes';
import notes from './notes/routes';
// import socket from './socketService';

const router: Router = Router();

router.use('/users', users);
router.use('/notes', notes);
// router.use('/socket', socket);

export default router;