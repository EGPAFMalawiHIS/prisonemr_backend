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
