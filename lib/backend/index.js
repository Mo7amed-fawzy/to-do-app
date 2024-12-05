const app = require("./app");
const db = require('./config/db');


app.get('/', (req, res) => {
    res.send('hellow from the server')
});


const port = 3000;

app.listen(port, () => {
    console.log(`Server Listening on Port http://localhost:${port}`);
});
