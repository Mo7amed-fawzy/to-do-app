const app = require("./app");
const db = require('./config/db');
const userModel = require('./model/user.model')
const todoModel = require('./model/todo.model')


app.get('/', (req, res) => {
    res.send('hellow from the server')
});


const port = 8080;

app.listen(port, '0.0.0.0', () => {
    console.log(`Server Listening on Port http://localhost:${port}`);
});

// controller بهندل الريكويست والريسبونس من الفرونت
// services collaborations(التعاون)to database