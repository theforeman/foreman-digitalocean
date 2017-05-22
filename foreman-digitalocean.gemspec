$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'foreman_digitalocean/version'
require 'date'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'foreman_digitalocean'
  s.version     = ForemanDigitalocean::VERSION
  s.date        = Date.today.to_s
  s.authors     = ['Tommy McNeely, Daniel Lobato']
  s.email       = ['elobatocs@gmail.com']
  s.homepage    = 'http://github.com/theforeman/foreman-digitalocean'
  s.summary     = 'Provision and manage DigitalOcean droplets from Foreman'
  s.description = 'Provision and manage DigitalOcean droplets from Foreman.'
  s.licenses    = ['GPL-3']

  s.files = Dir['{app,config,db,lib,locale}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'fog-digitalocean', '~> 0.3'

  s.add_development_dependency 'rubocop', '~> 0.42'
end
