const db = require('../util/database');

module.exports = class patient {
	constructor(prisonname,fullname,gender,registrationdate,entrydate,dob,regtype,cjnumber,cellnumber,hivstatus,
		        artyes,artno,tbyes,tbno,stiyes,stino,artstartdate,artnumber,regimen,nextappointment,
            currentvl,vleligibledate) {

		this.prisonname = prisonname;
		this.fullname = fullname;
		this.gender = gender;
		this.registrationdate = registrationdate;
		this.entrydate = entrydate;
		this.dob = dob;
		this.regtype = regtype;
		this.cjnumber = cjnumber;
		this.cellnumber = cellnumber;
		this.hivstatus = hivstatus;
		this.artyes = artyes;
		this.artno = artno;
		this.tbyes = tbyes;
		this.tbno = tbno;
		this.stiyes = stiyes;
		this.stino = stino;
		this.artstartdate = artstartdate;
		this.artnumber = artnumber;
		this.regimen = regimen;
		this.nextappointment = nextappointment;
		this.currentvl = currentvl;
		this.vleligibledate =vleligibledate;

	}

	static find(email) {
		return db.execute(` SELECT * FROM inmates WHERE cjnumber = '${cjnumber}' `);
	}

	/*static save(patient) {
		return db.execute(

			`INSERT INTO inmates (prisonname,fullname,gender,registration_date,entry_date,dob,reg_type,cj_number,cell_number,hiv_status,art_status,tb_status,
			                      sti_status,art_start_date,art_number,regimen,next_appointment,current_vl,vleligible_date )
			 VALUES ('${patient.prisonname}', '${patient.fullname}','${patient.gender}','${patient.registrationdate}','${patient.entrydate}','${patient.dob}',
			  '${patient.regtype}','${patient.cjnumber}','${patient.cellnumber}','${patient.hivstatus}','${patient.artyes}','${patient.tbyes}',
			  '${patient.stiyes}','${patient.artstartdate}','${patient.artnumber}','${patient.regimen}', '${patient.nextappointment}', '${patient.currentvl}','${patient.vleligibledate}')`
		);
	}*/


	static save(patient) {
		return db.execute(

			`INSERT INTO demographics (prisonname,fullname,gender,reg_date,entry_date,dob_birth,reg_type,criman_justice,cell_number,hiv_status,art_status,tb_status,
			                      sti_status)
			 VALUES ('${patient.prisonname}', '${patient.fullname}','${patient.gender}','${patient.registrationdate}','${patient.entrydate}','${patient.dob}',
			  '${patient.regtype}','${patient.cjnumber}','${patient.cellnumber}','${patient.hivstatus}','${patient.artyes}','${patient.tbyes}',
			  '${patient.stiyes}')`
		);
	}
};
