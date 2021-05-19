const db = require('../util/database');
const date = new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '')

function uuid() {                                  
                    return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g,function(){return(0|Math.random()*16)
                    	                               .toString(16)});
                  }


module.exports = class user {
	constructor(lname,fname,email,password,person_id,uroles,usersroles,dateofbirth,gender,userid,middle_name,attribute_id,attribute_value) {
		this.fname = fname;
		this.lname = lname;
		this.email = email;
		this.password = password;
		this.person_id = person_id;
		this.usroles = uroles;
		this.usersroles =usersroles;
		this.dateofbirth = dateofbirth;
		this.gender =gender;
		this.userid =userid;
		this.middle_name =middle_name;
		this.attribute_id =attribute_id;
		this.attribute_value =attribute_value;
	}	
     
    
    static search(user) {

		return db.execute(`SELECT * FROM role`);
	}


	static find(user) {
		return db.execute(`SELECT * FROM users WHERE username = '${user.email}'`);
	}

	static retrieve(user) {
		return db.execute(`SELECT * FROM person_name WHERE person_id = '${user.person_id}'`);
	}

	static save(user) {

	  return db.execute(

			`INSERT INTO person (gender,birthdate,birthdate_estimated,dead,cause_of_death,creator,date_created,voided,uuid) 
			VALUES ('${user.gender}','${user.dateofbirth}','0','0','1067','${user.userid}','${date}','0','${uuid()}')`
		);
			
	}

 static record(user) {

	  return db.execute(

			`INSERT INTO person_name (preferred,person_id,given_name,middle_name,family_name,creator,date_created,voided,uuid) 
			VALUES ('1','${user.person_id}','${user.fname}','${user.middle_name}','${user.lname}','${user.userid}','${date}','0','${uuid()}')`

		);}

  static store(user) {

	  return db.execute(

			`INSERT INTO person_address (preferred,person_id,creator,date_created,voided,uuid) 
			VALUES ('0','${user.person_id}','${user.userid}','${date}','0','${uuid()}')`

		);}


 static keep(user) {

	  return db.execute(

			`INSERT INTO person_attribute (person_id,person_attribute_type_id,value,creator,date_created,voided,uuid) 
			VALUES ('${user.person_id}','${user.attribute_id}','${user.attribute_value}','${user.userid}','${date}','0','${uuid()}')`

		);}

	    
	  static saves(user) {

	  return db.execute(

			`INSERT INTO users (user_id,system_id,username,password,salt,creator,date_created,person_id,uuid) 
			VALUES ('${user.person_id}','admin','${user.email}','${user.password}','${uuid()}','${user.userid}','${date}','${user.person_id}','${uuid()}')`

		);}

	   static saving(user) {

	  return db.execute(

			`INSERT INTO user_role (user_id,role) 
			VALUES ('${user.person_id}','${user.usersroles}')`

		);}



};
