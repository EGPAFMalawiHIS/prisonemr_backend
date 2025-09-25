# scripts/fix_tables.rb
require 'securerandom'

conn = ActiveRecord::Base.connection

# 1. Check and alter 'location' table
location_default = conn.select_value(<<-SQL)
  SELECT COLUMN_DEFAULT
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = 'location' AND COLUMN_NAME = 'date_created';
SQL

if location_default.nil? || location_default.upcase != 'CURRENT_TIMESTAMP'
  puts "[INFO] Updating 'location.date_created' default to CURRENT_TIMESTAMP"
  conn.execute("ALTER TABLE location MODIFY COLUMN date_created DATETIME DEFAULT CURRENT_TIMESTAMP;")
else
  puts "[SKIP] 'location.date_created' already has default CURRENT_TIMESTAMP"
end

# 2. Check and alter 'order_type' table
order_type_default = conn.select_value(<<-SQL)
  SELECT COLUMN_DEFAULT
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_NAME = 'order_type' AND COLUMN_NAME = 'date_created';
SQL

if order_type_default.nil? || order_type_default.upcase != 'CURRENT_TIMESTAMP'
  puts "[INFO] Updating 'order_type.date_created' default to CURRENT_TIMESTAMP"
  conn.execute("ALTER TABLE order_type MODIFY COLUMN date_created DATETIME DEFAULT CURRENT_TIMESTAMP;")
else
  puts "[SKIP] 'order_type.date_created' already has default CURRENT_TIMESTAMP"
end

# 3. Insert into location if it doesn't exist
existing = conn.select_value(<<-SQL)
  SELECT COUNT(*) FROM location WHERE name = 'Nkhatabay Prison Clinic';
SQL

if existing.to_i == 0
  puts "[INFO] Inserting new location 'Nkhatabay Prison Clinic'"
  conn.execute(<<-SQL)
    INSERT INTO location (name, description, city_village, country, creator, date_created, uuid)
    VALUES (
      'Nkhatabay Prison Clinic',
      'Health Centre',
      'Nkhatabay',
      'Malawi',
      1,
      CURRENT_TIMESTAMP,
      '#{SecureRandom.uuid}'
    );
  SQL
else
  puts "[SKIP] Location 'Nkhatabay Prison Clinic' already exists"
end

# 3. Insert into location if it doesn't exist
existing = conn.select_value(<<-SQL)
  SELECT COUNT(*) FROM location WHERE name = 'Ntchisi Prison Clinic';
SQL

if existing.to_i == 0
  puts "[INFO] Inserting new location 'Ntchisi Prison Clinic'"
  conn.execute(<<-SQL)
    INSERT INTO location (name, description, city_village, country, creator, date_created, uuid)
    VALUES (
      'Ntchisi Prison Clinic',
      'Health Centre',
      'Ntchisi',
      'Malawi',
      1,
      CURRENT_TIMESTAMP,
      '#{SecureRandom.uuid}'
    );
  SQL
else
  puts "[SKIP] Location 'Ntchisi Prison Clinic' already exists"
end

# 3. Insert into location if it doesn't exist
existing = conn.select_value(<<-SQL)
  SELECT COUNT(*) FROM location WHERE name = 'Rumphi Prison Clinic';
SQL

if existing.to_i == 0
  puts "[INFO] Inserting new location 'Rumphi Prison Clinic'"
  conn.execute(<<-SQL)
    INSERT INTO location (name, description, city_village, country, creator, date_created, uuid)
    VALUES (
      'Rumphi Prison Clinic',
      'Health Centre',
      'Rumphi',
      'Malawi',
      1,
      CURRENT_TIMESTAMP,
      '#{SecureRandom.uuid}'
    );
  SQL
else
  puts "[SKIP] Location 'Rumphi Prison Clinic' already exists"
end

# Rails script to update observations without using CSV files
# Place this in db/scripts/ or run via rails runner

# Collect next appointment observations
next_appointment_data = []
Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
           .joins("INNER JOIN encounter_type ON encounter_type.encounter_type_id = encounter.encounter_type")
           .where(obs: { concept_id: 5096 },
                  encounter: { 
                    encounter_type: EncounterType.find_by_name('HIV CLINIC REGISTRATION'),
                    program_id: Program.find_by_name('ART PROGRAM').id
                  }).each do |obs|
  next_appointment_data << {
    obs_id: obs.obs_id,
    concept_id: obs.concept_id,
    encounter_id: obs.encounter_id,
    value_datetime: obs.value_datetime,
    value_text: obs.value_text
  }
end

puts "Collected #{next_appointment_data.length} next appointment observations"

# Collect current regimen observations
current_regimen_data = []
Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
           .joins("INNER JOIN encounter_type ON encounter_type.encounter_type_id = encounter.encounter_type")
           .where(obs: { concept_id: 6882 },
                  encounter: { 
                    encounter_type: EncounterType.find_by_name('HIV CLINIC REGISTRATION'),
                    program_id: Program.find_by_name('ART PROGRAM').id
                  }).each do |obs|
  current_regimen_data << {
    obs_id: obs.obs_id,
    concept_id: obs.concept_id,
    encounter_id: obs.encounter_id,
    value_datetime: obs.value_datetime,
    value_text: obs.value_text
  }
end

puts "Collected #{current_regimen_data.length} current regimen observations"

# Process current regimen data - update concept_id to 5096
current_regimen_data.each do |row|
  available = Observation.find_by_obs_id(row[:obs_id])
  if available.present?
    available.concept_id = 5096
    available.save
    puts "Updated observation #{row[:obs_id]} concept_id to 5096"
  end
end

# Process next appointment data - update based on value_datetime presence
next_appointment_data.each do |row|
  available = Observation.find_by_obs_id(row[:obs_id])
  if available.present?
    if row[:value_datetime].present?
      begin
        date = Date.parse(row[:value_datetime].to_s)
        if date.is_a?(Date)
          available.concept_id = 5096
          available.save
          puts "Updated observation #{row[:obs_id]} concept_id to 5096 (has valid date)"
        end
      rescue ArgumentError
        # Invalid date format, treat as no date
        available.concept_id = 6882
        available.save
        puts "Updated observation #{row[:obs_id]} concept_id to 6882 (invalid date)"
      end
    else
      available.concept_id = 6882
      available.save
      puts "Updated observation #{row[:obs_id]} concept_id to 6882 (no date)"
    end
  end
end

# Update cervical cancer screening observations (1786 -> 9881)
puts "Processing cervical cancer screening observations..."
cervical_cancer_count = 0
Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
           .joins("INNER JOIN encounter_type ON encounter_type.encounter_type_id = encounter.encounter_type")
           .where(obs: { concept_id: 1786 },
                  encounter: { 
                    encounter_type: EncounterType.find_by_name('CERVICAL CANCER SCREENING'),
                    program_id: Program.find_by_name('ART PROGRAM').id
                  }).each do |obs|
  obs.concept_id = 9881
  obs.save
  cervical_cancer_count += 1
  puts "Updated observation #{obs.obs_id} concept_id from 1786 to 9881"
end

puts "Updated #{cervical_cancer_count} cervical cancer screening observations"

# Update HIV testing observations (9881 -> 1786)
puts "Processing HIV testing observations..."
hiv_testing_count = 0
Observation.joins("INNER JOIN encounter ON encounter.voided = 0 AND encounter.patient_id = obs.person_id")
           .joins("INNER JOIN encounter_type ON encounter_type.encounter_type_id = encounter.encounter_type")
           .where(obs: { concept_id: 9881 },
                  encounter: { 
                    encounter_type: EncounterType.find_by_name('HIV testing'),
                    program_id: Program.find_by_name('ART PROGRAM').id
                  }).each do |obs|
  obs.concept_id = 1786
  obs.save
  hiv_testing_count += 1
  puts "Updated observation #{obs.obs_id} concept_id from 9881 to 1786"
end

puts "Updated #{hiv_testing_count} HIV testing observations"

puts "Script completed successfully!"

 # Update Zomba Prison to Zomba Central Prison Clinic
        old_zomba_location = Location.find_by(name: "Zomba Prison")
        new_zomba_location = Location.find_by(name: "Zomba Central Prison Clinic")

      if old_zomba_location && new_zomba_location
           PersonAttribute.where(value: "Zomba Prison").find_each do |site|
                     site.update!(value: "Zomba Central Prison Clinic")
        end

        PatientIdentifier.where(location_id: old_zomba_location.location_id).find_each do |site|
                     site.update!(location_id: new_zomba_location.location_id)
        end
      else
         puts "One of the Zomba locations was not found."
      end

       # Update Chichiri Prison to Chichiri Prison Clinic
       old_chichiri_location = Location.find_by(name: "Chichiri Prison")
       new_chichiri_location = Location.find_by(name: "Chichiri Prison Clinic")

      if old_chichiri_location && new_chichiri_location
            PersonAttribute.where(value: "Chichiri Prison").find_each do |site|
                      site.update!(value: "Chichiri Prison Clinic")
             end

          PatientIdentifier.where(location_id: old_chichiri_location.location_id).find_each do |site|
                      site.update!(location_id: new_chichiri_location.location_id)
          end
      else
          puts "One of the Chichiri locations was not found."
      end


      PersonAttribute.where(value: 1,person_attribute_type_id: 42).find_each do |site|
                     site.update!(value: "Remandee")
      end
      PersonAttribute.where(value: 2,person_attribute_type_id: 42).find_each do |site|
                     site.update!(value: "Convict")
      end
      PersonAttribute.where(value: 3,person_attribute_type_id: 42).find_each do |site|
                     site.update!(value: "Staff")
      end

def insert_person_attribute_type(conn, name, description)
  existing = conn.select_value(<<-SQL)
    SELECT COUNT(*) FROM person_attribute_type WHERE name = '#{name}';
  SQL

  if existing.to_i == 0
    puts "[INFO] Inserting #{name} attribute"
    conn.execute(<<-SQL)
      INSERT INTO person_attribute_type (name, description, creator, date_created, uuid)
      VALUES (
        '#{name}',
        '#{description}',
        1,
        CURRENT_TIMESTAMP,
        '#{SecureRandom.uuid}'
      );
    SQL
  else
    puts "[SKIP] #{name} attribute already exists"
  end
end

# Usage - Insert all person attribute types
attributes = [
  {
    name: 'HIV status at entry',
    description: 'Patient HIV status at entry into facility e.g prisons'
  },
  {
    name: 'Initiate on ART',
    description: 'Patient ART status at entry into facility e.g prisons'
  },
  {
    name: 'TB History',
    description: 'Patient TB History at entry into facility e.g prisons'
  },
  {
    name: 'STI History',
    description: 'Patient STI History at entry into facility e.g prisons'
  },
  {
    name: 'Current Place Of Residence',
    description: 'Patient Current Place Of Residence into a facility at entry e.g prisons'
  },
  {
    name: 'Criminal Justice Number',
    description: 'Patient Criminal Justice Number into a facility at entry e.g prisons'
  },
  {
    name: 'Entry Date',
    description: 'Patient Date of Entry into a facility e.g prisons'
  },
  {
    name: 'Registration Type',
    description: 'Patient Registration Type into a facility e.g Convict'
  },
  {
    name: 'Prisoner gender',
    description: 'Patient Gender type identifier'
  },
  {
    name: 'Cell Number',
    description: 'Patient Cell Number in the prison facility'
  },
  {
    name: 'Registration date',
    description: 'Patient date of registration'
  }
]

# Insert all attributes
attributes.each do |attr|
  insert_person_attribute_type(conn, attr[:name], attr[:description])
end
      


