const { validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const User = require('../models/user');
const Patient = require('../models/patient');
const tbscreen = require('../models/tbscreen');
const artscreen = require('../models/artscreen');
const stiscreen = require('../models/stiscreen');
const Metadata = require('../models/metadata');
const totals =0;


exports.user_roles = async (req, res, next) => {

	const uroles = req.body.usroles;
	

	try {

		const sroles = await User.search(uroles);

		res.status(200).json(sroles[0]);


	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};


exports.regimens = async (req, res, next) => {

	const reg = req.body.regimens;
	

	try {

		const sroles = await Metadata.find(reg);

		res.status(200).json(sroles[0]);


	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};



exports.prisons = async (req, res, next) => {

	const prison = req.body.locations;

	try {

		const prisons_array = await Metadata.search(prison);

		res.status(200).json(prisons_array[0]);


	} catch (err) {
		if (!err.statusCode) {
			res.statusCode = 500;
		}
		next(err);
	}
};



exports.signup = async (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) return;

	const fname = req.body.fname;
	const lname = req.body.lname;
	const email = req.body.email;
	const password = req.body.password;
	const userx = req.body.usersroles;

	try {

		       const pDetails ={email:email}

		const user = await User.find(pDetails);

		if (user[0].length == 1) {
			const error = Error('User with this email exists.');
			error.statusCode = 401;
			throw error;
			totals++;

		}	
		
		
	  /* const hashedPassword = await bcrypt.hash(password, 12);

		const userDetails = {
			    fname: fname,
			    lname: lname,
		  dateofbirth:"2000-05-18",
		       userid:1,
		       gender:"M",						
		};

		const result = await User.save(userDetails);


		if(result.length){

			 const id = result[0].insertId;

		const personDetails = {
			      person_id: id,
			      fname: fname,
			     middle_name:null,
			     userid:1,
			      lname: lname,
			 usersroles: userx,
			     email: email,
			     password: hashedPassword,
		     };

			const person_name = await User.record(personDetails);

			const person_address = await User.store(personDetails);

			const users = await User.saves(personDetails);

			const usersroles = await User.saving(personDetails);


		}*/

		res.status(201).json({ message: "Account created successfully!" });



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
           const pDetails ={email:email}
		const user = await User.find(pDetails);

		if (user[0].length !== 1) {
			const error = Error('User email could not be found.');
			error.statusCode = 401;
			throw error;
			totals++;

		}

		const storedUser = user[0][0];

		const isEqual = await bcrypt.compare(password, storedUser.password);
		if (!isEqual) {
			const error = Error('Invalid password');
			error.statusCode = 401;
			throw error;
			totals++;
		}
       
         const personBio = {person_id: storedUser.user_id};
		       const bio = await User.retrieve(personBio);

		const token = jwt.sign(
		{
			userId: storedUser.person_id,
			fname:bio[0][0].given_name,
			lname:bio[0][0].family_name,
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



exports.patient = async (req, res, next) => {
	const errors = validationResult(req);

	if (!errors.isEmpty()) return;

	const prisonname = req.body.prisonname;
	const fullname = req.body.fullname;
	var gender = req.body.gender;
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
	const vleligibledate=req.body.vleligibledate;
	var admuser=req.body.userId;
	var admuser=admuser.toString();
    const name_array = fullname.split(" ");
    const fname =name_array[0];
    var mname =name_array[1];
    var lname =name_array[2];
    var gender_description;
       

	try {
           if (gender ==1){        
                         gender ="M";
                         gender_description ="Male";
                      }
                 else{
                        
                        if (gender ==2){                            
                            gender_description ="FP";
                        }
                        else if(gender ==3){
                            gender_description ="FNP";
                        }
                        else{
                              gender_description ="FBF";
                            }

                       gender ="F";
                     }
           if (lname ==null){        
                         lname =mname;
                         mname =null;
                      }


		const userDetails = {
			
			     gender: gender,			
			dateofbirth: dob,
			    userid: admuser,

		};

	   const result = await User.save(userDetails);


		if(result.length){

			 const id = result[0].insertId;

		const personDetails = {
			     person_id: id,
			      fname: fname,
			      lname: lname,
			middle_name: mname,
			   userid: admuser,
			   
		     };

            const personAtt =[];

              personAtt.push({    attribute_id:18,
               	               attribute_value:cellnumber });
               personAtt.push({   attribute_id:23,
               	               attribute_value:hivstatus });
               personAtt.push({   attribute_id:30,
               	               attribute_value:cjnumber });
               personAtt.push({   attribute_id:31,
               	               attribute_value:entrydate });
               personAtt.push({   attribute_id:32,
               	               attribute_value:regtype });
                personAtt.push({   attribute_id:33,
               	               attribute_value: gender_description });

              for(var i =0; i < personAtt.length;i++ ){

                         const att_person = {

		         person_id: id,
			  attribute_id: personAtt[i].attribute_id,
		   attribute_value: personAtt[i].attribute_value,
			   userid: admuser,
			   
		                       };

		        const person_attribute = await User.keep(att_person);

              }

		     

			const person_name = await User.record(personDetails);

			const patients = await Patient.save(personDetails);

            const personsEncounter = {
			     person_id: id,
			      prison:prisonname,
			      reg_date: registrationdate,
			      encounter_type: 5,
			        userid: admuser,			   
		     };

			const encounter = await Patient.enc(personsEncounter);

			       const eid =encounter[0].insertId;

			const personsObs = {
			     person_id: id,
			     encounter_id:eid,
			     prison:prisonname,
			      reg_date: registrationdate,			   
			    userid: admuser,
			    concept_id :3289,
			   
		     };

			const obs = await Patient.obs(personsObs);


		}

		res.status(201).json({message:"Imnate demographics captured successfully!!"});
         //res.status(201).json(personsObs)


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