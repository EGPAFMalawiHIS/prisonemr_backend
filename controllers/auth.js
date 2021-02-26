const { validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');

const bcrypt = require('bcryptjs');
const User = require('../models/user');

const totals =0;

exports.signup = async (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) return;

	const name = req.body.name;
	const email = req.body.email;
	const password = req.body.password;

	try {
		const hashedPassword = await bcrypt.hash(password, 12);

		const userDetails = {
			name: name,
			email: email,
			password: hashedPassword,
		};

		const result = await User.save(userDetails);

		res.status(201).json({ message: 'User created succesully.' });



	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};

exports.login = async (req, res, next) => {
	const email = req.body.email;
	const password = req.body.password;

	try {
		const user = await User.find(email);
		if (user[0].length !== 1) {
			const error = Error('User email could not be found.');
			error.statusCode = 401;
			throw error;
			total;

		}
		const storedUser = user[0][0];

		const isEqual = await bcrypt.compare(password, storedUser.password);
		if (!isEqual) {
			const error = Error('Invalid password');
			error.statusCode = 401;
			throw error;
			total;
		}
		const token = jwt.sign(
			{
				email: storedUser.email,
				userId: storedUser.id,
			},
			'mySecretKey',
			{
				expiresIn: '12h',
			}
		);

		res.status(200).json({ token: token, userId: storedUser.id });

       
	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};

exports.logout = async (req, res) => {
  
   
    res.status(200);
  
};
