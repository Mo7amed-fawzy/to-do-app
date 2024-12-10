const router = require('express').Router();
const todoController = require('../controller/todo.controller');


router.post('/storeTodo', todoController.createToDo);

module.exports = router;