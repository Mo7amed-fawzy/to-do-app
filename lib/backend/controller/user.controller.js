const UserServices = require('../services/user.services');

// فنكشن بتهندل الريك والريسبونس
exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body; //  بستخرج الايميل والباس من بودي الريكويست (req.body).

        const successRes = await UserServices.registraterUser(email, password);

        res.json({ status: true, success: "User Register Successfully" }); // ببعت دي للفرونت
    } catch (error) { // إذا حدث خطأ، يتم تمريره باستخدام throw ليتم معالجته في مكان آخر (Middleware مثل Express error handler).
        throw error;
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            // ! if email undefined or null or "" this con is true
            throw new Error('Parameter are not correct');
        }
        let user = await UserServices.checkUser(email);
        if (!user) {
            throw new Error('User does not exist');
        }
        const isPasswordCorrect = await user.comparePassword(password);
        if (isPasswordCorrect === false) {
            throw new Error(`Username or Password does not match`);
        }
        // Creating Token
        let tokenData;
        tokenData = { _id: user._id, email: user.email };

        const token = await UserServices.generateAccessToken(tokenData, "secret", "1h")
        res.status(200).json({ status: true, success: "sendData", token: token });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}