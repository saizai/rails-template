# My version of an app template, modified by James Cox (imajes)
# SUPER DARING APP TEMPLATE 1.0 - By Peter Cooper
# further modified by Sai Emrys (saizai)

# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm public/images/rails.png"
run "rm -f public/javascripts/*"

# Set up .gitignore files
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-END
.DS_Store
log/*.log
log/*.pid
tmp/**/*
config/database.yml
db/*.sqlite3
db/*.db
db/schema.rb
vendor/rails
END

# Set up session store initializer
initializer 'session_store.rb', <<-END
ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
ActionController::Base.session_store = :active_record_store
  END

initializer 'ar-extensions.rb', <<-END
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'
END


initializer 'google-analytics.rb', <<-END
#Rubaidh::GoogleAnalytics.tracker_id = 'UA-######-#'
END

intializer 'exception-notifier.rb', <<-END
ExceptionNotifier.exception_recipients = %w(example@example.com)
END

initializer 'workling.rb', <<-END
#Workling::Remote.dispatcher = Workling::Remote::Runners::SpawnRunner.new # This will run async tasks via Spawn
Workling::Remote.dispatcher = Workling::Remote::Runners::StarlingRunner.new # This will run async tasks via Starling
Workling::Return::Store.instance = Workling::Return::Store::StarlingReturnStore.new
END

file 'app/views/layouts/_flashes.html.erb',
%q{<div id="flash">
<% flash.each do |key, value| -%>
<div id="flash_<%= key %>"><%=h value %></div>
<% end -%>
</div>
}

initializer 'time_formats.rb',
%q{# Example time formats
{ :short_date => "%x", :long_date => "%a, %b %d, %Y" }.each do |k, v|
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(k => v)
end
}

# Utility
gem 'mislav-will_paginate'
gem 'markcatley-google_analytics'
gem 'ar-extensions'
gem 'utf8proc'
gem 'RedCloth', :lib => 'redcloth'
# plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git'
plugin 'bundle-fu', :git => 'git://github.com/timcharper/bundle-fu.git'
plugin 'exception_notification', :git => 'git://github.com/rails/exception_notification.git'
plugin 'graceful_mailto_obfuscator', :svn => 'http://svn.playtype.net/plugins/graceful_mailto_obfuscator/'
plugin 'white_list', :svn => 'http://svn.techno-weenie.net/projects/plugins/white_list/'
plugin 'squirrel', :git => 'git://github.com/thoughtbot/squirrel.git'
# Caching
gem 'fiveruns-memcache-client'
gem 'cache-fu'
# Meta & debugging
gem 'capistrano'
capify!
file 'Capfile',
%q{load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'
}

gem 'piston'
gem 'ruby-debug'
#
 Inline debugging helpers
plugin 'debug-view-helper', :svn => 'http://www.realityforge.org/svn/public/code/debug-view-helper/trunk'
plugin 'browser-logger', :svn => 'svn://rubyforge.org/var/svn/browser-logger'
plugin 'browser-prof', :svn => 'svn://rubyforge.org/var/svn/browser-prof'

if yes?("Use starling/workling for backgrounding?")
	gem 'starling-starling'
	plugin 'workling', :git => 'git://github.com/purzelrakete/workling.git'
	plugin 'workling_mailer', :git => 'git://github.com/langalex/workling_mailer.git'
	plugin 'spawn', :git => 'git://github.com/tra/spawn.git'
end

if yes?("Use Juggernaut for push?")
	gem 'json'
	gem 'eventmachine'
	gem 'juggernaut'
	plugin 'juggernaut_plugin', :git => 'git://github.com/maccman/juggernaut_plugin.git'
	run 'juggernaut -g config/juggernaut.yml'
end
	
if yes?("Use rmagick? (WARNING: Major pain to install!)")
	gem 'rmagick'
end

if yes?("Use Facebook?")
	gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
	plugin 'facebooker', :git => 'git://github.com/mmangino/facebooker.git'
	initializer 'mime_types.rb', %q{Mime::Type.register_alias 'text/html', :fbml}
end

if yes?("Be paranoid about recordkeeping and versioning?")
	plugin 'acts_as_paranoid', :git => 'git://github.com/technoweenie/acts_as_paranoid.git'
	plugin 'acts_as_versioned', :git => 'git://github.com/technoweenie/acts_as_versioned.git'	
end

if yes?("Use SSL?")
	plugin 'asset-hosting-with-minimum-ssl', :git => 'git://github.com/dhh/asset-hosting-with-minimum-ssl.git'
end


if yes?("Have authenticated users?")
	plugin 'aasm', :git => 'git://github.com/rubyist/aasm.git'
#	plugin 'acts_as_state_machine', :git => 'git://github.com/omghax/acts_as_state_machine.git' # older than aasm

	plugin 'acts_as_preferenced', :git => 'git://github.com/Skiz/acts_as_preferenced.git'
	plugin 'user_stamp', :git => 'git://github.com/jnunemaker/user_stamp.git'
	plugin 'validates_email_veracity_of', :git => 'git://github.com/Empact/validates_email_veracity_of.git'
#	plugin 'rails-authorization-plugin', :git => 'git://github.com/DocSavage/rails-authorization-plugin.git'
#  plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'
#  plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git'
  plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
#  gem 'ruby-openid', :lib => 'openid'  
  generate("authenticated", "user session")
  generate("roles", "Role User")
  rake('open_id_authentication:db:create')
end

# tags
if yes?("Do you want tags with that?")
  plugin 'acts_as_taggable_redux', :git => 'git://github.com/geemus/acts_as_taggable_redux.git'
  rake('acts_as_taggable:db:create')
end

# Final install steps
rake('gems:install', :sudo => true)
rake('db:sessions:create')
rake('db:migrate')

# Commit all work so far to the repository
git :add => '.'
git :commit => "-a -m 'Initial commit'"

# Success!
puts "SUCCESS!"
