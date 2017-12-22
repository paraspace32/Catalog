Fabricator(:product) do
  name          { Faker::Name.name }
  description   { Faker::Lorem.words(10).join(', ') }
  price         { Faker::Number.number(2).to_i }
end