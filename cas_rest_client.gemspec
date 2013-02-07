# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cas_rest_client}
  s.version = "1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Antonio Marques, Roberto Klein"]
  s.date = %q{2010-09-16}
  s.email = ["acmarques@gmail.com", "robertokl@gmail.com"]
  s.files = ["lib/cas_rest_client/cas_rest_client.rb", "lib/cas_rest_client.rb"]
  s.homepage = %q{http://github.com/robertokl/cas-rest-client}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Rest client to interact with CASified services.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 1.4.2"])
    else
      s.add_dependency(%q<rest-client>, [">= 1.4.2"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 1.4.2"])
  end
  
  s.add_development_dependency 'rspec'
end
