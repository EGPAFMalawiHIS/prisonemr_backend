const express = require('express');
const { body } = require('express-validator');
const jwt = require('jsonwebtoken');

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

router.get('/userid',verifytoken,function (req, res,next){

         res.status(200).json(decodedToken.userId);

});

var decodedToken ="";

function verifytoken(req,res,next){

 let token = req.query.token;

 jwt.verify(token,'mySecretKey', function(error,tokendata){
 	 if (error){
 	 	            return res.status(400).json({message: "Unauthorised request"})
 	 }
 	 if (tokendata){
 	 	         
 	 	         decodedToken = tokendata;
 	 	         next();
 	 	   	 }
 })

}


router.post('/patientregister', authController.patient);

router.post('/tbscreen', authController.tbscreen);

router.post('/artscreen', authController.artscreen);

router.post('/stiscreen', authController.stiscreen);

module.exports = router;
