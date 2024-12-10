const db = require('../config/db');
const mongoose = require('mongoose');
const userModel = require('../model/user.model');

const Schema = mongoose.Schema;

const todoSchema = new Schema({
    userId: { // جزء من عملية ال Authorization والعملية اسمها (Reference)
        type: Schema.Types.ObjectId,
        ref: userModel.modelName // مرجع ل Document في مجموعة المستخدمين (الهو الايميل)
    },
    title: {
        type: String,
        require: true
    },
    desc: {
        type: String,
        require: true
    }
});

const todoModel = db.model('todo', todoSchema); // اسم الداتابيز كولكشن

module.exports = todoModel;