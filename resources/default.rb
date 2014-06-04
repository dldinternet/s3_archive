actions :create
attribute :remote_path, :kind_of => String, :name_attribute => true
attribute :bucket, :kind_of => String
attribute :aws_access_key_id, :kind_of => String
attribute :aws_secret_access_key, :kind_of => String
attribute :token, :kind_of => String, :default => nil
attribute :user, :kind_of => [String, NilClass], :default => nil
attribute :group, :kind_of => [String, NilClass], :default => nil
attribute :mode, :kind_of => [String, NilClass], :default => nil
attribute :tar_flags, :kind_of => Array, :default => []
attribute :target_dir, :kind_of => String
attribute :creates, :kind_of => String
attribute :timestamp, :kind_of => String, :default => Time.new.to_s
attribute :download_dir, :kind_of => String, :default => "/tmp"
attribute :overwrite, :kind_of => [TrueClass, FalseClass], :default => false

def initialize(*args)
  #noinspection RubySuperCallWithoutSuperclassInspection
  super
  @action = :create
end