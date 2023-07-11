import App from './app';

const port = process.env.PORT as unknown as number || 3000;

App.startServer(port);