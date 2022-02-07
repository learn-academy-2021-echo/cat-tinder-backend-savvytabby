# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

cats = [
  {
    name: "Mittens",
    age: 5,
    enjoys: "Sunshine and warm spots",
    image: "https://images.unsplash.com/photo-1543852786-1cf6624b9987?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
  },
  {
    name: "Raisins",
    age: 4,
    enjoys: "Being queen of the dogs",
    image: "https://images.unsplash.com/photo-1533743983669-94fa5c4338ec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1092&q=80"
  },
  {
    name: "Toast",
    age: 1,
    enjoys: "Getting all the attention",
    image: "https://images.unsplash.com/photo-1592194996308-7b43878e84a6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"
  },
  {
    name: "Barbie",
    age: 7,
    enjoys: "BBQ Lamb",
    image: "https://cdna.artstation.com/p/assets/images/images/031/676/102/large/ana-silence-43565431-2067439716641364-1574266016911851520-n.jpg?1604298130"
  },
  {
    name: "Shiba",
    age: 3,
    enjoys: "Walking like a doggy",
    image: "https://www.cnet.com/a/img/eWPU7u1-GqGoyEnxge8fLWLyUzg=/2016/11/10/6f83754e-d0b9-4d92-91eb-10773bc2edd0/atchoum2.jpg"
  },
  {
    name: "Teddy",
    age: 6,
    enjoys: "Always wear a hat",
    image: "https://i.pinimg.com/564x/33/32/6d/33326dcddbf15c56d631e374b62338dc.jpg"
  }
]

cats.each do |values|
  # active record query
  Cat.create values
  p "creating cats #{values}"
end
