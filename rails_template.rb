# My version of an app template, modified by James Cox (imajes)
# SUPER DARING APP TEMPLATE 1.0 - By Peter Cooper
# further modified by Sai Emrys (saizai)

# invoke using:
#  rails projectnamehere -m http://github.com/saizai/rails-template/raw/master/rails_template.rb


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
config/initializers/site_keys.rb
END

# Set up session store initializer
initializer 'session_store.rb', <<-END
ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
ActionController::Base.session_store = :active_record_store
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
gem 'mislav-will_paginate', :lib => 'will_paginate'
gem 'markcatley-google_analytics', :lib => 'google_analytics'
initializer 'google-analytics.rb', <<-END
#Rubaidh::GoogleAnalytics.tracker_id = 'UA-######-#'
END
gem 'ar-extensions'
initializer 'ar-extensions.rb', <<-END
require 'ar-extensions/adapters/mysql'
require 'ar-extensions/import/mysql'
END
gem 'utf8proc'
gem 'RedCloth', :lib => 'redcloth'
# plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git'
plugin 'bundle-fu', :git => 'git://github.com/timcharper/bundle-fu.git'
plugin 'exception_notification', :git => 'git://github.com/rails/exception_notification.git'
initializer 'exception-notifier.rb', <<-END
ExceptionNotifier.exception_recipients = %w(example@example.com)
END
plugin 'graceful_mailto_obfuscator', :svn => 'http://svn.playtype.net/plugins/graceful_mailto_obfuscator/'
plugin 'white_list', :svn => 'http://svn.techno-weenie.net/projects/plugins/white_list/'
plugin 'squirrel', :git => 'git://github.com/thoughtbot/squirrel.git'
# Caching
gem 'memcache-client', :git => 'git://github.com/mperham/memcache-client.git'
plugin 'cache_fu', :git => 'git://github.com/defunkt/cache_fu.git'
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
# Inline debugging helpers
plugin 'debug-view-helper', :svn => 'http://www.realityforge.org/svn/public/code/debug-view-helper/trunk'
# plugin 'browser-logger', :svn => 'svn://rubyforge.org/var/svn/browser-logger' # generates error - browser-logger.rb:47:in `alias_method': undefined method `out' for class `ActionController::CgiResponse' (NameError)
plugin 'browser-prof', :svn => 'svn://rubyforge.org/var/svn/browser-prof'

if yes?("Use starling/workling for backgrounding?")
	gem 'starling-starling'
	plugin 'workling', :git => 'git://github.com/purzelrakete/workling.git'
	plugin 'workling_mailer', :git => 'git://github.com/langalex/workling_mailer.git'
	plugin 'spawn', :git => 'git://github.com/tra/spawn.git'
	initializer 'workling.rb', <<-END
#Workling::Remote.dispatcher = Workling::Remote::Runners::SpawnRunner.new # This will run async tasks via Spawn
Workling::Remote.dispatcher = Workling::Remote::Runners::StarlingRunner.new # This will run async tasks via Starling
Workling::Return::Store.instance = Workling::Return::Store::StarlingReturnStore.new
	END
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
	gem 'mysql_bigint_ids', :git => 'git://github.com/gumayunov/mysql_bigint_ids.git'
	plugin 'facebooker', :git => 'git://github.com/mmangino/facebooker.git'
	initializer 'mime_types.rb', %q{Mime::Type.register_alias 'text/html', :fbml}
end

if yes?("Be paranoid about recordkeeping and versioning?")
	plugin 'acts_as_paranoid', :git => 'git://github.com/technoweenie/acts_as_paranoid.git'
	plugin 'acts_as_versioned', :git => 'git://github.com/technoweenie/acts_as_versioned.git'	
end

if yes?("Use SSL?")
	plugin 'asset-hosting-with-minimum-ssl', :git => 'git://github.com/dhh/asset-hosting-with-minimum-ssl.git'
	plugin 'ssl_requirement', :git => 'git://github.com/bcurren/ssl_requirement.git'
end


if yes?("Have authenticated users?")
	plugin 'aasm', :git => 'git://github.com/rubyist/aasm.git'
#	plugin 'acts_as_state_machine', :git => 'git://github.com/omghax/acts_as_state_machine.git' # older than aasm

	plugin 'acts_as_preferenced', :git => 'git://github.com/Skiz/acts_as_preferenced.git'
	plugin 'user_stamp', :git => 'git://github.com/jnunemaker/user_stamp.git'
	plugin 'validates_email_veracity_of', :git => 'git://github.com/Empact/validates_email_veracity_of.git'
	
	gem 'ruby-openid', :lib => 'openid'  
	rake('gems:install', :sudo => true) # must install gems before running rake
	plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'
	rake('open_id_authentication:db:create')
	
	plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
	generate("authenticated", "user session --include-activation --aasm") # also should include --rspec if rspec is installed
	route "map.signup  '/signup', :controller => 'users',   :action => 'new'"
	route "map.login  '/login',  :controller => 'session', :action => 'new'"
	route "map.logout '/logout', :controller => 'session', :action => 'destroy'"
	route "map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil"
	route "map.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete }"
	initializer 'restful-auth.rb', <<-END
		ActiveRecord::Base.observers += [UserObserver]
		ActiveRecord::Base.instantiate_observers
	END
file 'app/models/user_observer.rb', <<-END
    class UserObserver < ActiveRecord::Observer
      def after_create(user)
        user.reload
        UserMailer.deliver_signup_notification(user)
      end
      def after_save(user)
        user.reload
        UserMailer.deliver_activation(user) if user.recently_activated?
      end
    end
end
	
# 	plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git' # these two are competitors. role_req is simpler.
#	generate("roles", "Role User")
# vs.
	plugin 'rails-authorization-plugin', :git => 'git://github.com/DocSavage/rails-authorization-plugin.git'
	initializer 'authorization.rb', <<-END
  # NOTE: This may need to be moved to BEFORE the rails initializer block in environment.rb
  # Add to the User model:
  #     acts_as_authorized_user
  #     acts_as_authorizable  # also add this to other models that take roles

  # Authorization plugin for role based access control
  # You can override default authorization system constants here.

  # Can be 'object roles' or 'hardwired'
  AUTHORIZATION_MIXIN = "object roles"

  # NOTE : If you use modular controllers like '/admin/products' be sure
  # to redirect to something like '/sessions' controller (with a leading slash)
  # as shown in the example below or you will not get redirected properly
  #
  # This can be set to a hash or to an explicit path like '/login'
  #
  LOGIN_REQUIRED_REDIRECTION = { :controller => '/sessions', :action => 'new' }
  PERMISSION_DENIED_REDIRECTION = { :controller => '/home', :action => 'index' }

  # The method your auth scheme uses to store the location to redirect back to
  STORE_LOCATION_METHOD = :store_location
END
	generate("role_model", "Role")
# end of authorization plugin - phew

end

rake('gems:install', :sudo => true) # must install gems before running rake

# tags
if yes?("Do you want tags with that?")
  plugin 'acts_as_taggable_redux', :git => 'git://github.com/geemus/acts_as_taggable_redux.git'
  rake('acts_as_taggable:db:create')
end

# Final install steps
# rake('gems:install', :sudo => true)
rake('db:sessions:create')
rake('db:migrate')

# Commit all work so far to the repository
git :add => '.'
git :commit => "-a -m 'Initial commit'"

# Success!
puts "SUCCESS!"
