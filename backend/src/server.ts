import express, { Request, Response } from 'express';

const app = express();
const port = 3000;

// Middleware to parse JSON requests
app.use(express.json());

// Simple GET endpoint
app.get('/', (req: Request, res: Response) => {
  res.send('Hello, World!');
});

// Example API to simulate fetching user data
app.get('/users', (req: Request, res: Response) => {
  const users = [
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' },
  ];
  res.json(users);
});

// POST endpoint to simulate creating a new user
app.post('/users', (req: Request, res: Response) => {
  const newUser = req.body;
  // In a real app, you'd save the new user to a database
  res.status(201).json({ message: 'User created', user: newUser });
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
