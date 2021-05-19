const db = require('../util/database');



module.exports = class metadata {
	constructor(reg,prison) {
		this.reg = reg;
		this.prison = prison;
		
	}	
     
    
    static find(metadata) {

		return db.execute(`SELECT * FROM moh_regimen_name`);
	}


	
   static search(metadata) {

		return db.execute(`SELECT * FROM location WHERE description='Prison'`);
	}


};
