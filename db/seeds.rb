# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

boards = ["mainboard", "organic_search", "social", "email", "direct", "paid"]
boards.each do |board|
  50.times do |i|
    param = {
      name: Faker::Name.name,
      avatar: "https://loremflickr.com/300/300/people",
      score: Random.rand(100),
      id: i,
      organic: Random.rand(100),
      social: Random.rand(100),
      email: Random.rand(100),
      direct: Random.rand(100),
      paid: Random.rand(100)
    }
    param[:board_name] = board

    Boards::UpdateService.new.execute(param)


  end
end
