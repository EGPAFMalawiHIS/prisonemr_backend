const db = require('../util/database');

module.exports = class tbscreen {
	constructor( patientid,artyes,artno,screenreason,screeneddate,tbscreeningresults,
				specimencollected_yes,specimencollected_no,reason_no_sputum,
				type_specimen,specify_specimen,type_test,specify_labtest,
				tb_testing_date,micro_examination,specify_examination,test_performed,
				specify_testPerformed,results_a,microscopy_results,rif_results,
				rif_ultra_results,diagnosis_outcome_a,diagnosis_type_a,treatment_a,
				reason_treatment,tb_initiated_date,tb_treatment_type_a,ishiv_yes,
				ishiv_no,tptdate) {
        
        this.patientid = patientid;       
		this.artyes = artyes;
		this.artno = artno;
		this.screenreason = screenreason;
		this.screeneddate = screeneddate;
		this.tbscreeningresults = tbscreeningresults;
		this.specimencollected_yes = specimencollected_yes;
		this.specimencollected_no = specimencollected_no;
		this.reason_no_sputum = reason_no_sputum;
		this.type_specimen = type_specimen;
		this.specify_specimen = specify_specimen;
		this.type_test = type_test;
		this.specify_labtest = specify_labtest;
		this.tb_testing_date = tb_testing_date;
		this.micro_examination = micro_examination;
		this.specify_examination = specify_examination;
		this.specify_examination = specify_examination;
		this.artstartdate = artstartdate;
		this.test_performed = test_performed;
		this.specify_testPerformed = specify_testPerformed;
		this.results_a = results_a;
		this.microscopy_results = microscopy_results;
		this.rif_results =rif_results;
		this.rif_ultra_results=rif_ultra_results;
		this.diagnosis_outcome_a=diagnosis_outcome_a;
		this.diagnosis_type_a=diagnosis_type_a;
		this.treatment_a=treatment_a;
		this.reason_treatment=reason_treatment;
		this.tb_initiated_date=tb_initiated_date;
		this.tb_treatment_type_a=tb_treatment_type_a;
		this.ishiv_yes=ishiv_yes;
		this.ishiv_no=ishiv_no;
		this.tptdate=tptdate;

	}

	//static find(email) {
		//return db.execute(` SELECT * FROM inmates WHERE cjnumber = '${cjnumber}' `);
	//}

	/*static save(patient) {
		return db.execute(

			`INSERT INTO inmates (prisonname,fullname,gender,registration_date,entry_date,dob,reg_type,cj_number,cell_number,hiv_status,art_status,tb_status,
			                      sti_status,art_start_date,art_number,regimen,next_appointment,current_vl,vleligible_date )
			 VALUES ('${patient.prisonname}', '${patient.fullname}','${patient.gender}','${patient.registrationdate}','${patient.entrydate}','${patient.dob}',
			  '${patient.regtype}','${patient.cjnumber}','${patient.cellnumber}','${patient.hivstatus}','${patient.artyes}','${patient.tbyes}',
			  '${patient.stiyes}','${patient.artstartdate}','${patient.artnumber}','${patient.regimen}', '${patient.nextappointment}', '${patient.currentvl}','${patient.vleligibledate}')`
		);
	}*/


	static save(tbscreen) {
		return db.execute(

			`INSERT INTO tbscreen (patient_id,art_status,reason_screening,date_created,tb_screening_result)
			 VALUES ('${tbscreen.patientid}', '${tbscreen.artno}','${tbscreen.screenreason}','${tbscreen.screeneddate}','${tbscreen.tbscreeningresults}')`
		);
	}
};
