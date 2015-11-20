$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "oauth2_hmac_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "oauth2_hmac_rails"
  s.version     = Oauth2HmacRails::VERSION
  s.authors     = ["Mustafa TURAN"]
  s.email       = ["mustafaturan.net@gmail.com"]
  s.homepage    = "https://github.com/mustafaturan/oauth2_hmac_rails"
  s.summary     = "Authorization server 'Rails Engine' for Oauth2 HMac Draft 01."
  s.description = "Authorization server 'Rails Engine' for Oauth2 HMac Draft 01."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency "oauth2_hmac_header", "~> 0.1.2"
  s.add_dependency "attr_encrypted"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails", "~> 4.0"
end
