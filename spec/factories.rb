Factory.define :user do |user|
  user.username "Test Testson"
  user.email "test@test.test"
  user.password "testing"
  user.password_confirmation "testing"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :macropost do |mp|
  mp.content "Foo bar"
  mp.title "title here"
  mp.location_id 1
  mp.association :user
end
