run "echo TODO > README"

if yes?("Do you want to use RSpec?")
  plugin "rspec", :git => "git:"
end

if yes?("Do you want to use jrails?")
  plugin "jrails", :git => "git://github.com/aaronchi/jrails.git"
end

if yes?("Do you want to use formtastic?")
  gem "formtastic"
  rake "gems:install"
  rake "gems:unpack"
end

if yes?("Do you want to use thoughtbot-clearance?")
  gem "thoughtbot-clearance",
    :lib     => 'clearance',
    :source  => 'http://gems.github.com',
    :version => '>= 0.8.2'
  rake "gems:install"
  rake "gems:unpack"
  generate "clearance"
  generate "clearance_views"
end

if yes?("Do you want to generate nifty_layout?")
  generate "nifty_layout"
end

generate :controller, "top", "index"
route "map.root :controller => :top"

git :init
file ".gitignore", <<-END
.DS_Store
*.swp
log/*.log
log/*.pid
tmp/**/*
config/database.yml
db/*.sqlite3
config/environments/development.rb
*.tmproj
coverage
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/example_database.yml"
run "rm public/index.html"

git :add => "."
git :commit => "-m 'initial commit'"
