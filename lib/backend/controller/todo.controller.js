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
exports.deleteTodo = async (req, res, next) => {
    try {
        const { itemId } = req.body; // 

        let deleted = await ToDoServices.DeleteTodo(itemId);

        res.json({ status: true, success: deleted })
    } catch (error) {
        next(error);
    }
}

exports.updateTodo = async (req, res, next) => {
    try {
        const { itemId, title, desc } = req.body; // استلام البيانات من الفرونت

        const updateFields = { title, desc };

        let updated = await ToDoServices.updateTodo(itemId, updateFields);

        res.json({ status: true, success: updated });
    } catch (error) {
        next(error);
    }
};





//         response.json(product);
//     } catch (err) {
//         console.log(err);
//         response.status(500).json({ error: "An error occurred while updating the product." });
//     }
// });