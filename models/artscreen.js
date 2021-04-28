const db = require('../util/database');

module.exports = class artscreen {
	constructor(patientid,artstartdate,artnumber,regimen,nextappointment,
            currentvl,vleligibledate) {

		this.patientid = patientid;		
		this.artstartdate = artstartdate;
		this.artnumber = artnumber;
		this.regimen = regimen;
		this.nextappointment = nextappointment;
		this.currentvl = currentvl;
		this.vleligibledate =vleligibledate;

	}

	//static find(email) {
		//return db.execute(` SELECT * FROM inmates WHERE cjnumber = '${cjnumber}' `);
	//}

	static save(artscreen) {
		return db.execute(

			`INSERT INTO artscreen (patient_id,art_start_date,art_number,regimen,next_appointment,current_vl,vleligible_date)
			 VALUES ('${artscreen.patientid}', '${artscreen.artstartdate}','${artscreen.artnumber}','${artscreen.regimen}',
			 '${artscreen.nextappointment}','${artscreen.currentvl}','${artscreen.vleligibledate}')`
		);
	}
};
