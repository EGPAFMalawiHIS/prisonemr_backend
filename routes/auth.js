const express = require('express');
const { body } = require('express-validator');

const authController = require('../controllers/auth');

const router = express.Router();
const User = require('../models/user');

router.post(
	'/signup',
	[
		body('name').trim().not().isEmpty(),
		body('email')
			.isEmail()
			.withMessage('Enter valid email')
			.custom(async (email) => {
				const user = await User.find(email);
				if (user[0].length > 0) {
					return Promise.reject('Email alredy exists');
				}
			})
			.normalizeEmail(),
		body('password').trim().isLength({ min: 6 }),
	],
	authController.signup
);

router.post('/login', authController.login);
router.get('/logout', authController.logout);

module.exports = router;
