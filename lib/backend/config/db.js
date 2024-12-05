const mongoose = require('mongoose');

const connection = mongoose.createConnection(`mongodb://localhost:27017/ToDoDB`)
    .on('open', () => { console.log("MongoDB Connected"); })
    .on('error', () => {
        console.log("MongoDB Connection error");
    });
// Mongodb compass is graphical user interface
module.exports = connection; 