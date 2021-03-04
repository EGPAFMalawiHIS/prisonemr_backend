const { validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');

const bcrypt = require('bcryptjs');
const User = require('../models/user');
const Patient = require('../models/patient');

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


		res.status(200).json(token);

       
	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};

//exports.username = async (req, res,next) => {
  
   
    //res.status(200);
  
//};





exports.patient = async (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) return;

	const prisonname = req.body.prisonname;
	const fullname = req.body.fullname;
	const gender = req.body.gender;
	const registrationdate = req.body.registrationdate;
	const entrydate =req.body.entrydate;
    const dob = req.body.dob;
    const regtype = req.body.regtype;
    const cjnumber = req.body.cjnumber;
    const cellnumber = req.body.cellnumber;
    const hivstatus = req.body.hivstatus;
    const artyes = req.body.artyes;
    const tbyes = req.body.tbyes;
    const stiyes =req.body.stiyes;
    const artstartdate = req.body.artstartdate;
    const artnumber = req.body.artnumber;
    const regimen =req.body.regimen;
	const nextappointment = req.body.nextappointment;
	const currentvl= req.body.currentvl;
	const vleligibledate=req.body.vleligibledate

	try {
		

		const userDetails = {

			prisonname: prisonname,
			fullname: fullname,
			gender: gender,
			registrationdate: registrationdate,
			entrydate: entrydate,
		    dob: dob,
		    regtype: regtype,
		    cjnumber:cjnumber,
		    cellnumber:cellnumber,
		    hivstatus: hivstatus,
		    artyes: artyes,
		    tbyes: tbyes,
		    stiyes: stiyes,
		    artstartdate: artstartdate,
		    artnumber:artnumber,
		    regimen:regimen,
	        nextappointment:nextappointment,
	        currentvl:currentvl,
	       vleligibledate:vleligibledate

		};

		const result = await Patient.save(userDetails);

		res.status(201).json({ message: 'Patient demographics captured succesully.' });



	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};