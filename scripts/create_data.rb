Company.destroy_all
Contact.destroy_all
Post.destroy_all
User.destroy_all

# Create companies

apple = Company.new
apple["name"] = "Apple"
apple["city"] = "Cupertino"
apple["state"] = "CA"
apple["url"] = "https://apple.com"
apple.save

amazon = Company.new
amazon["name"] = "Amazon"
amazon["city"] = "Seattle"
amazon["state"] = "WA"
amazon["url"] = "https://amazon.co"
amazon.save

anthropic = Company.new
anthropic["name"] = "Anthropic"
anthropic["city"] = "San Francisco"
anthropic["state"] = "CA"
anthropic["url"] = "https://anthropic.com"
anthropic.save

# Create contacts

tim = Contact.new
tim["first_name"] = "Tim"
tim["last_name"] = "Cook"
tim["email"] = "tim@apple.com"
tim["phone_number"] = "777-777-7777"
tim["company_id"] = apple.id
tim.save

craig = Contact.new
craig["first_name"] = "Craig"
craig["last_name"] = "Federighi"
craig["email"] = "craig@apple.com"
craig["phone_number"] = "888-888-8888"
craig["company_id"] = apple.id
craig.save

andy = Contact.new
andy["first_name"] = "Andy"
andy["last_name"] = "Jassy"
andy["email"] = "andy@amazon.com"
andy["phone_number"] = "666-666-6666"
andy["company_id"] = amazon.id
andy.save

dario = Contact.new
dario["first_name"] = "Dario"
dario["last_name"] = "Amodei"
dario["email"] = "dario@anthropic.com"
dario["phone_number"] = "555-555-5555"
dario["company_id"] = anthropic.id
dario.save

puts "There are now #{Company.all.count} companies and #{Contact.all.count} contacts."

# Create posts

post = Post.new
post["author"] = "Ben"
post["body"] = "My first Tacostagram post!"
post["image"] = "https://images.unsplash.com/photo-1607891715106-ba61a2951650?q=80&w=2258&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
post.save

post = Post.new
post["author"] = "Brian"
post["body"] = "Yummmm!"
post["image"] = "https://images.unsplash.com/photo-1511690078903-71dc5a49f5e3?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
post.save

puts "There are now #{Post.all.count} Tacostagram posts."

# Create users
#
# These two rows came over from the old system, where passwords were kept as typed.
# The User model may check passwords on the way in; rows that predate it are saved
# without those checks, so they stay as the old system left them.

ben = User.new
ben["first_name"] = "Ben"
ben["last_name"] = "Block"
ben["email"] = "ben@example.com"
ben["password"] = "tacos123"
ben.save(:validate => false)

brian = User.new
brian["first_name"] = "Brian"
brian["last_name"] = "Uzzi"
brian["email"] = "brian@example.com"
brian["password"] = "password"
brian.save(:validate => false)

puts "There are now #{User.all.count} users."
