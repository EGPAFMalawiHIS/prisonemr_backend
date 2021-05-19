const db = require('../util/database');

module.exports = class stiscreen {
	constructor(patientid,artstartdate,artnumber,regimen,nextappointment,
            currentvl,vleligibledate) {

		    this.patientid=patientid;
			this.stiyes= stiyes;
			this.stino= stino;
			this.screenreason=screenreason;
			this.doneyes= doneyes;
			this.doneno= doneno;
			this.sti_testing_date=sti_testing_date;
			this.resultsyes= resultsyes;
			this.resultsno= resultsno;
			this.treatmentyes= treatmentyes;
			this.treatmentno=treatmentno;
			this.sti_treatment_date= sti_treatment_date;
			this.next_sti_treatment_date=next_sti_treatment_date;
			this.completed_sti_treatment_date=completed_sti_treatment_date;  

	}

	//static find(email) {
		//return db.execute(` SELECT * FROM inmates WHERE cjnumber = '${cjnumber}' `);
	//}

	static save(stiscreen) {
		return db.execute(

			`INSERT INTO stiscreen (patient_id,sti_status,screen_reason,done_status,sti_testing_date,results_status,treatment_status,sti_treatment_date,next_treatment_date,completed_treatment_date)
			 VALUES ('${stiscreen.patientid}', '${stiscreen.stiyes}','${stiscreen.screenreason}','${stiscreen.doneyes}','${stiscreen.sti_testing_date}',
			 '${stiscreen.resultsyes}','${stiscreen.treatmentyes}','${stiscreen.sti_treatment_date}','${stiscreen.next_sti_treatment_date}','${stiscreen.completed_sti_treatment_date}')`
		);
	}
};
