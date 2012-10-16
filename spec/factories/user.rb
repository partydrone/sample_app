Factory.define :user do |u|
  u.name 'Example User %d'
  u.email 'user%d@example.com'
  u.password 'password'
  u.password_confirmation 'password'
end
