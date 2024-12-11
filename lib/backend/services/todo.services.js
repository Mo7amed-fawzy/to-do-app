//1 class layer
const todoModel = require('../model/todo.model');

class ToDoServices {
    static async createToDo(userId, title, desc) {
        const createToDo = new todoModel({ userId, title, desc });

        return await createToDo.save();
    }

    static async getTododata(userId) {
        const todoData = await todoModel.find({ userId });

        return todoData;
    }

    static async DeleteTodo(itemId) {
        const deleted = await todoModel.findByIdAndDelete(itemId);


        return deleted;
    }

    static async updateTodo(itemId, updateFields) {
        const updatedTodo = await todoModel.findByIdAndUpdate(itemId, updateFields, { new: true });

        return updatedTodo;
    }

}

module.exports = ToDoServices;

// create بضيف كلو
// get اليوزر ايدي بس