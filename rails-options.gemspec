require_relative 'lib/rails/options/version'

Gem::Specification.new do |spec|
  spec.name = 'rails-options'
  spec.version = Rails::Options::VERSION
  spec.authors = ['Moku S.r.l.', 'Riccardo Agatea']
  spec.email = ['info@moku.io']

  spec.summary = 'xyz'
  spec.description = 'xyz'
  spec.homepage = 'https://bitbucket.org/moku_team/rails-options'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://bitbucket.org/moku_team/rails-options'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir File.expand_path(__dir__) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 7.0'
end
