const mongoose = require('mongoose');
const db = require('../config/db');

const Schema = mongoose.Schema;

const userSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
});

const userModel = db.model('user', userSchema); // اسم الداتابيز كولكشن

module.exports = userModel;
