//1 class layer
const todoModel = require('../model/todo.model');

class ToDoServices {
    static async createToDo(userId, title, desc) {
        const createToDo = new todoModel({ userId, title, desc });

        return await createToDo.save();
    }
}

module.exports = ToDoServices;