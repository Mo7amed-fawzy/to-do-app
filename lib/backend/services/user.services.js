const userModel = require('../model/user.model')

class UserService {

    static async registraterUser(email, password) {
        try {
            const createUser = new userModel({ email, password }); // هنا بخزن فالداتابيز
            return await createUser.save()
        } catch (err) {
            throw err;
        }
    }
}

module.exports = UserService;