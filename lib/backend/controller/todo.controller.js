//2
const ToDoServices = require('../services/todo.services');

exports.createToDo = async (req, res, next) => { // باخد 3 بارامترز من الفرونت
    try {
        const { userId, title, desc } = req.body;

        let todo = await ToDoServices.createToDo(userId, title, desc); // باخد من الفرونت وبحط فالخانات

        res.json({ status: true, success: todo })
    } catch (error) {
        next(error);
    }
}
exports.getUserTodo = async (req, res, next) => {
    try {
        const { userId } = req.body; // 

        let todo = await ToDoServices.getTododata(userId);

        res.json({ status: true, success: todo })
    } catch (error) {
        next(error);
    }
}