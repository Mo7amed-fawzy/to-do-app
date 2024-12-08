const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcrypt');

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

userSchema.pre('save', async function () {
    try {
        const user = this;
        const salt = await bcrypt.genSalt(10); // دي سترنج عشوائي بيضاف قبل التشفير
        const hashedPassword = await bcrypt.hash(user.password, salt); // بشفر كلمة المرور مع السولت
        user.password = hashedPassword;
    } catch (err) {
        console.error('Error hashing password:', err.message);
        throw err;
    }
});


const userModel = db.model('user', userSchema); // اسم الداتابيز كولكشن

module.exports = userModel;
