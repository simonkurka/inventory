# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
@i1 = Item.create(name: 'Universe', description: 'Our Universe, maybe there are more human-like objects out there', created_at: DateTime.now)
@i2 = Item.create(name: 'Earth', description: 'Our Planet, mostly water on the Surface', created_at: DateTime.now, parent_id: @i1.id)
@i3 = Item.create(name: 'Europe', description: 'Our Continent, also holds Greenwich Middle Time', created_at: DateTime.now, parent_id: @i2.id)
@i4 = Item.create(name: 'Germany', description: 'Our Country, one of the biggest in Europe', created_at: DateTime.now, parent_id: @i3.id)

100.times do |i|
  Item.create(name: "TestObject N° #{i+1}", description: 'We have 100 Test Object for testing our database and our frontend', created_at: DateTime.now, parent_id: @i4.id)
end
