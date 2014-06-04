#!/usr/bin/env ruby
# s3_archive/libraries/matchers.rb

if defined?(ChefSpec)
	def create_s3_archive(path)
		ChefSpec::Matchers::ResourceMatcher.new(:s3_archive, :create, path)
	end
end