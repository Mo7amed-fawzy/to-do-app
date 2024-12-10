const express = require("express");
const app = express();
const body_parser = require('body-parser');
const userRouter = require('./routes/user.router');
const ToDoRouter = require('./routes/todo.router');

app.use(body_parser.json());

app.use('/', userRouter); // كل الhttp هتتوجه للروتر دا 
app.use('/', ToDoRouter);

module.exports = app;