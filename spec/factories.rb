Factory.define :user do |user|
  user.name                  "Ronald Spork"
  user.email                 "rspork@example.com"
  user.password              "spork4ever"
  user.password_confirmation "spork4ever"
end

Factory.sequence :email do |n| 
  "person-#{n}@example.com"
end

Factory.define :recipe do |recipe|
  recipe.instructions "Preheat to 350 then cook"
  recipe.association :user
end