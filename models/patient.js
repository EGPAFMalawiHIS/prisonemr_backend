const db = require('../util/database');
const date = new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '')

function uuid() {                                  
                    return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g,function(){return(0|Math.random()*16)
                    	                               .toString(16)});
                  }

module.exports = class patient {
	constructor(person_id,userid,prison,encounter_type,reg_date,concept_id,encounter_id) {

		this.person_id = person_id;		
		this.userid =userid;
		this.prison =prison;
		this.encounter_type= encounter_type;
		this.reg_date = reg_date;
		this.concept_id = concept_id;
		this.encounter_id =encounter_id;
		
	}

	static find(email) {
		//return db.execute(` SELECT * FROM inmates WHERE cjnumber = '${cjnumber}' `);
	}

	static save(patient) {
		return db.execute(

			`INSERT INTO patient (patient_id,creator)
			 VALUES ('${patient.person_id}', '${patient.userid}')`
		);
	}

static enc(patient) {
		return db.execute(

			 `INSERT INTO encounter (encounter_type,patient_id,creator,provider_id,location_id,encounter_datetime,date_created,uuid)
			 VALUES ('${patient.encounter_type}','${patient.person_id}','${patient.userid}','${patient.userid}','${patient.prison}','${patient.reg_date}','${date}','${uuid()}')`
		);
	}


	static obs(patient) {
		return db.execute(

			 `INSERT INTO obs (person_id,concept_id,encounter_id,location_id,obs_datetime,date_created,uuid,creator,value_coded)
			 VALUES ('${patient.person_id}','${patient.concept_id}','${patient.encounter_id}','${patient.prison}','${patient.reg_date}','${date}','${uuid()}','${patient.userid}','7572')`
		);
	}


	
};
