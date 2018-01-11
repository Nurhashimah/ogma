# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# 
# 

# $ psql
# psql (9.3.4)
# Type "help" for help.
# 
# postgres=# \c icms_demo_test
# You are now connected to database "icms_demo_test" as user "postgres".
# icms_demo_test=# insert into colleges(id, code, name) values (1, 'amsas','Kolej 2');
# INSERT 0 1
# icms_demo_test=# insert into pages(id, name, title, navlabel, position, college_id) values (1,'home', 'Homepage', 'label1', 1,1);
# INSERT 0 1
