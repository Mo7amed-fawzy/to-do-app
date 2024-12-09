const userModel = require('../model/user.model')
const jwt = require("jsonwebtoken");

class UserService {
    // static هنا شبه لما اعمل ابستراكت كلاس
    static async registraterUser(email, password) {
        try {
            const createUser = new userModel({ email, password }); // هنا بخزن فالداتابيز
            return await createUser.save()
        } catch (err) {
            throw err;
        }
    }

    static async checkUser(email) {
        try {
            return await userModel.findOne({ email });
        } catch (error) {
            throw error;
        }
    }


    //  tokenData بتبقي اوبجكت فيه الايميل ويوزر ايدي
    //  JWTSecret_Key مفتاح سري يُستخدم لتوقيع البيانات فالتكونداتا
    //  JWT_EXPIRE مدة صلاحية الJWT و expiresIn دي كدا مدة محدده
    static async generateAccessToken(tokenData, JWTSecret_Key, JWT_EXPIRE) {
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
}

module.exports = UserService;