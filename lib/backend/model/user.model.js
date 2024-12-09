const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcrypt');

const Schema = mongoose.Schema;

const userSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: [true, "userName can't be empty"],
        // // @ts-ignore
        // match: [
        //     /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
        //     "userName format is not correct",
        // ],
        // unique: true,
    },
    password: {
        type: String,
        required: [true, "password is required"],
    },
}, { timestamps: true });


// اسم الحدث الذي تريد تشغيل الوظيفة قبل تنفيذه hook
// schema.pre(hook, callback); وهي فنكشن بستعملها قبل عمل حاجه معينه
userSchema.pre('save', async function () {
    try {
        const user = this; // دي شايله الحجات ال انا مباصيها الهي الايميل والباسس (ال document الحالي)

        // تشفير كلمة السر
        const salt = await bcrypt.genSalt(10); // دي سترنج عشوائي بيضاف قبل التشفير
        const hashedPassword = await bcrypt.hash(user.password, salt); // بشفر كلمة المرور مع السولت
        user.password = hashedPassword;

    } catch (err) {
        console.error('Error hashing password:', err.message);
        throw err;
    }
});

//used while signIn decrypt
userSchema.methods.comparePassword = async function (candidatePassword) {
    try {
        console.log('----------------no password', this.password);
        // @ts-ignore
        const isMatch = await bcrypt.compare(candidatePassword, this.password);
        return isMatch;
    } catch (error) {
        throw error;
    }
};


const userModel = db.model('user', userSchema); // اسم الداتابيز كولكشن

module.exports = userModel;
