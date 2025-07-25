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


