const { validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');

const bcrypt = require('bcryptjs');
const User = require('../models/user');
const Patient = require('../models/patient');
const tbscreen = require('../models/tbscreen');
const artscreen = require('../models/artscreen');
const stiscreen = require('../models/stiscreen');

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



exports.tbscreen = async (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) return;

	const patientid = req.body.patientid;
	const artyes = req.body.artyes;
	const artno = req.body.artno;
	const screenreason = req.body.screenreason;
	const screeneddate = req.body.screeneddate;
	const tbscreeningresults =req.body.tbscreeningresults;
	const specimencollected_yes = req.body.specimencollected_yes;
	const specimencollected_no = req.body.specimencollected_no;
	const reason_no_sputum = req.body.reason_no_sputum;
	const type_specimen = req.body.type_specimen;
	const specify_specimen = req.body.specify_specimen;
	const type_test = req.body.type_test;
	const specify_labtest = req.body.specify_labtest;
	const tb_testing_date =req.body.tb_testing_date;
	const micro_examination = req.body.micro_examination;
	const specify_examination = req.body.specify_examination;
	const artstartdate =req.body.artstartdate;
	const test_performed = req.body.test_performed;
	const specify_testPerformed= req.body.specify_testPerformed;
	const results_a=req.body.results_a;
	const microscopy_results =req.body.microscopy_results;
	const rif_results =req.body.rif_results;
	const rif_ultra_results=req.body.rif_ultra_results;
	const diagnosis_outcome_a=req.body.diagnosis_outcome_a;
	const diagnosis_type_a=req.body.diagnosis_type_a;
	const treatment_a=req.body.treatment_a;
	const reason_treatment=req.body.reason_treatment;
	const tb_initiated_date=req.body.tb_initiated_date;
	const tb_treatment_type_a=req.body.tb_treatment_type_a;
	const ishiv_yes=req.body.ishiv_yes;
	const ishiv_no=req.body.ishiv_no;
	const tptdate=req.body.tptdate;

	try {


		const screenDetails = {

			patientid: patientid,
			artyes: artyes,
			artno: artno,
			screenreason: screenreason,
			screeneddate: screeneddate,
			tbscreeningresults: tbscreeningresults,
			specimencollected_yes: specimencollected_yes,
			specimencollected_no: specimencollected_no,
			reason_no_sputum: reason_no_sputum,
			type_specimen: type_specimen,
			specify_specimen: specify_specimen,
			type_test: type_test,
			specify_labtest: specify_labtest,
			tb_testing_date: tb_testing_date,
			micro_examination: micro_examination,
			specify_examination: specify_examination,
			artstartdate: artstartdate,
			test_performed: test_performed,
			specify_testPerformed: specify_testPerformed,
			results_a: results_a,
			microscopy_results: microscopy_results,
			rif_results: rif_results,
			rif_ultra_results: rif_ultra_results,
			diagnosis_outcome_a: diagnosis_outcome_a,
			diagnosis_type_a: diagnosis_type_a,
			treatment_a: treatment_a,
			reason_treatment: reason_treatment,
			tb_initiated_date: tb_initiated_date,
			tb_treatment_type_a: tb_treatment_type_a,
			ishiv_yes: ishiv_yes,
			ishiv_no: ishiv_no,
			tptdate: tptdate,

		};

		const result = await tbscreen.save(screenDetails);

		res.status(201).json({ message: 'Patient demographics captured succesully.' });



	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};



exports.artscreen = async (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) return;

	const patientid = req.body.patientid;
	const artstartdate = req.body.artstartdate;
	const artnumber = req.body.artnumber;
	const regimen =req.body.regimen;
	const nextappointment = req.body.nextappointment;
	const currentvl= req.body.currentvl;
	const vleligibledate=req.body.vleligibledate

	try {


		const userDetails = {

			patientid: patientid,
			artstartdate: artstartdate,
			artnumber:artnumber,
			regimen:regimen,
			nextappointment:nextappointment,
			currentvl:currentvl,
			vleligibledate:vleligibledate

		};

		const result = await artscreen.save(userDetails);

		res.status(201).json({ message: 'ART screen data captured succesully.' });



	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};


exports.stiscreen = async (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) return;

	const patientid = req.body.patientid;
	const stiyes = req.body.stiyes;
	const stino = req.body.stino;
	const screenreason =req.body.screenreason;
	const doneyes = req.body.doneyes;
	const doneno = req.body.doneno;
	const sti_testing_date =req.body.sti_testing_date;
	const resultsyes = req.body.resultsyes;
	const resultsno = req.body.resultsno;
	const treatmentyes = req.body.treatmentyes;
	const treatmentno =req.body.treatmentno;
	const sti_treatment_date = req.body.sti_treatment_date;
	const next_sti_treatment_date = req.body.next_sti_treatment_date;
	const completed_sti_treatment_date =req.body.completed_sti_treatment_date;

	try {


		const userDetails = {

			patientid:patientid,
			stiyes: stiyes,
			stino: stino,
			screenreason:screenreason,
			doneyes: doneyes,
			doneno: doneno,
			sti_testing_date:sti_testing_date,
			resultsyes: resultsyes,
			resultsno: resultsno,
			treatmentyes: treatmentyes,
			treatmentno:treatmentno,
			sti_treatment_date: sti_treatment_date,
			next_sti_treatment_date:next_sti_treatment_date,
			completed_sti_treatment_date:completed_sti_treatment_date


		};

		const result = await stiscreen.save(userDetails);

		res.status(201).json({ message: 'STI screen data captured succesully.' });



	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};