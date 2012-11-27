require 'rubygems'
require 'mysql'
database_name = "wikileak"
table_name = "cable"
csvfile = '/tmp/pathtocablefile/cables.csv'
m = Mysql.new("localhost", "username", "password")
m.select_db(database_name)
m.query("DROP TABLE IF EXISTS "+table_name)
ptable_create = "CREATE TABLE "+table_name+"(
id INT auto_increment primary key,
date CHAR(20),
code CHAR(50),
embassy CHAR(100),
class CHAR(50),
state CHAR(50),
sendto CHAR(200),
cabletext TEXT);"
m.query(ptable_create)
def save_to_db(cable_entry,table_name,m)
entry_field = 0
db_entry  = []
db_entry[7] = ''
#Remove unnecessary Commas
cable_entry = cable_entry.gsub('","',"$$")
cable_entry = cable_entry.gsub(",","")
cable_entry = cable_entry.gsub("$$",'","')
save_entry = cable_entry.split(",")
save_entry.each do |da_entry|
if entry_field == 7
db_entry[7] = db_entry[7]+da_entry
else
db_entry[entry_field] = da_entry
entry_field = entry_field + 1
end
valo = 0
end
pquery = "INSERT INTO `"+table_name+"` VALUES("+db_entry[0]+","+db_entry[1]+","+db_entry[2]+","+db_entry[3]+","+db_entry[4]+","+db_entry[5]+","+db_entry[6]+","+db_entry[7]+");"
m.query(pquery)
end
cable_entry = ''
seeknum = 1
seeker = '"'+seeknum.to_s()+'"'
File.open(csvfile).each do |record|
if record.match(seeker)
if seeknum &gt; 1
save_to_db(cable_entry,table_name,m)
puts "Saves: "+seeknum.to_s()
end
cable_entry = record
seeknum += 1
c_record_num = 1
seeker = '"'+seeknum.to_s()+'"'
else
cable_entry = cable_entry+record
end
end
m.close