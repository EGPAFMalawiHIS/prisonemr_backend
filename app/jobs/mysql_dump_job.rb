class MysqlDumpJob < ApplicationJob
  queue_as :default

  def perform
    facility = GlobalProperty.find_by(property: "current_health_center_name")&.property_value
    raise "Facility name not found!" if facility.blank?

    backup_dir = "/opt/prison/backups"
    filename = "#{facility}-#{Time.now.strftime('%Y-%m-%d')}.sql.gz"
    filepath = "#{backup_dir}/#{filename}"

    Dir.mkdir(backup_dir) unless Dir.exist?(backup_dir)

    dump_command = <<~CMD
      mysqldump -uroot -ppassword --host=0.0.0.0 -P3308 --no-tablespaces --skip-lock-tables openmrs_prison | gzip > #{filepath}
    CMD

    result = system(dump_command)

    if result
      Dir.glob("#{backup_dir}/#{facility}-*.sql.gz").each do |file|
        File.delete(file) unless file == filepath  # Don't delete the current file
      end
    else
      raise "MySQL dump failed for facility: #{facility}"
    end
  end
end


