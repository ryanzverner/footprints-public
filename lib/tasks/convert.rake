desc "convert a latin1 database with utf8 data into proper utf8"
task :convert_to_utf8 => :environment do
  puts Time.now
  dryrun = ENV['DOIT'] != '1'
  conn = ActiveRecord::Base.connection
  if dryrun
    def conn.run_sql(sql)
      puts(sql)
    end
  else
    def conn.run_sql(sql)
      puts(sql)
      execute(sql)
    end
  end

  conn.run_sql "ALERT DATABASE footprints CHARACTER SET utf8 collate utf8_unicode_ci"

  VIEWS = /(view|_v$)/
  big = []

  mapping = { :applicants => Applicant,
              :messages => Message,
              :craftsmen => Craftsman,
              :users => User,
              :schema_migrations => true,
  }.with_indifferent_access
  tables = (conn.tables - big).select { |table| table !~VIEWS }
  puts "Converting #{tables.inspect}"

  tables.each do |t|
    a = ['CHARACTER SET utf8 COLLATE utf8_unicode_ci']
    b = []
    model = mapping[t] || t.to_s.classify.constantize
    model.columns.each do |col|
      type = col.sql_type

      nullable = col.null ? '' : ' NOT NULL'
      default = col.default ? " DEFAULT '#{col.default}'" : ''

      case type
      when /varchar/
        a << "CHANGE #{col.name} #{col.name} VARBINARY(#{col.limit})"
        b << "CHANGE #{col.name} #{col.name} VARCHAR(#{col.limit}) CHARACTER SET utf8 COLLATE utf8_unicode_ci#{nullable}#{default}"
      when /text/
        a << "CHANGE #{col.name} #{col.name} BLOB"
        b << "CHANGE #{col.name} #{col.name} TEXT CHARACTER SET utf8 COLLATE utf8_unicore_ci#{nullable}#{default}"
      end
    end unless model == true

    conn.run_sql "ALTER TABLE #{t} #{a.join(', ')}"
    conn.run_sql "ALTER TABLE #{t} #{b.join(', ')}" if b.present?
  end

  puts Time.now
  puts "Done!"
end
