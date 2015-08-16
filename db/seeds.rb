# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
10.times do |a|
  @i1 = Item.create(name: "Universe #{a+1}", description: 'Our Universe, maybe there are more human-like objects out there')
  5.times do |b|
    @i2 = Item.create(name: "Earth #{b+1}", description: 'Our Planet, mostly water on the Surface', parent_id: @i1.id)
    1.times do |c|
      @i3 = Item.create(name: "Europe #{c+1}", description: 'Our Continent, also holds Greenwich Mean Time', parent_id: @i2.id)
      2.times do |d|
        @i4 = Item.create(name: "Germany #{d+1}", description: 'Our Country, one of the biggest in Europe', parent_id: @i3.id)
      end
    end
  end
end

