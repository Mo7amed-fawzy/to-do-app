const UserServices = require('../services/user.services');

// تسجيل المستخدم
exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        // تحقق من وجود الحقول المطلوبة
        if (!email || !password) {
            return res.status(400).json({ status: false, error: "Email and password are required" });
        }

        // استدعاء خدمة تسجيل المستخدم
        const successRes = await UserServices.registraterUser(email, password);

        // إرسال رد النجاح
        res.status(201).json({ status: true, success: "User registered successfully" });
    } catch (error) {
        console.error("Error in register function:", error.message);
        next(error); // تمرير الخطأ للـ middleware لمعالجته
    }
};

// تسجيل الدخول
exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        // تحقق من وجود الحقول المطلوبة
        if (!email || !password) {
            return res.status(400).json({ status: false, error: "Email and password are required" });
        }

        // التحقق من وجود المستخدم
        const user = await UserServices.checkUser(email);
        if (!user) {
            return res.status(404).json({ status: false, error: "User does not exist" });
        }

        // التحقق من صحة كلمة المرور
        const isPasswordCorrect = await user.comparePassword(password);
        if (!isPasswordCorrect) {
            return res.status(401).json({ status: false, error: "Invalid username or password" });
        }

        // إنشاء التوكن
        const tokenData = { _id: user._id, email: user.email };
        const token = await UserServices.generateAccessToken(tokenData, "secret", "1h");

        // إرسال رد النجاح
        res.status(200).json({ status: true, success: "Login successful", token });
    } catch (error) {
        console.error("Error in login function:", error.message);
        next(error); // تمرير الخطأ للـ middleware لمعالجته
    }
};
