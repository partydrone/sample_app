Factory.define :micropost do |f|
  f.content 'Lorem ipsum.'
  f.user { Factory :user }
end
