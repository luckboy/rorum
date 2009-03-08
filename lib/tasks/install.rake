desc "Install forum"
task(:install => :environment) do
  require 'rubygems'
  require 'highline/import'

  puts
  say "Configuring administrator account."
  puts

  login = ask("Login:")
  email = ask("Email:")
  password = ask("Password:") { |q| q.echo = "*"}
  password_confirmation = ask("Confirm password:") { |q| q.echo = "*" }

  # zalawanie schematow
  Rake::Task["db:schema:load"].invoke

  # rola administratora
  admin_role = Role.new(:name => "admin", :is_admin => true, :is_default => false)
  admin_role.rights_to_own_topic = 7
  admin_role.rights_to_other_topic = 7
  admin_role.rights_to_own_post = 7
  admin_role.rights_to_other_post = 7
  admin_role.save

  # administrator
  admin_user = User.create(:login => login, :email => email, :password => password, :password_confirmation => password_confirmation)
  if admin_user.errors.empty?
    admin_user.roles << admin_role

    # rola uzytkownika
    user_role = Role.new(:name => "user", :is_admin => false, :is_default => true)
    user_role.rights_to_own_topic = 1
    user_role.rights_to_other_topic = 0
    user_role.rights_to_own_post = 1
    user_role.rights_to_other_post = 0
    user_role.save

    # kategiria
    category = Category.create(:name => "First category")

    # forum
    forum = category.forums.create(:name => "First forum", :description => "This forum is exemple.")

    # dodanie forum do roli uzytkownika
    user_role.forums << forum
    user_role.save

    # watek
    topic = Topic.new(:subject => "Welcome to Rorum", :body => "Welcome to Rorum.\nThis post is exemple.")
    topic.author = admin_user
    forum.topics << topic
    topic.save
  else
    puts "Errors:"
    admin_user.errors.each { |attr, msg| puts "  #{attr} - #{msg}"}
    admin_role.destroy
  end
end
