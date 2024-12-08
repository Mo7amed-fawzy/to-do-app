const UserService = require('../services/user.services');

// فنكشن بتهندل الريك والريسبونس
exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body; // جاية من الفرونت

        const successRes = await UserService.registraterUser(email, password);

        res.json({ status: true, success: "User Register Successfully" });
    } catch (error) {
        throw error;
    }
}