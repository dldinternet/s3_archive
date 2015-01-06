#include S3File

require 'digest/md5'

action :create do
  basename = ::File.basename(new_resource.name)
  new_resource = @new_resource
  download = true
  overwrite = new_resource.overwrite
  download_dir = new_resource.download_dir
  local_archive = "#{download_dir}/#{basename}"
  token = new_resource.token

  # handle key specified without leading slash
  remote_path = new_resource.remote_path
  if remote_path.chars.first != '/'
    remote_path = "/#{remote_path}"
  end

  if ::File.exists? local_archive and download
    s3_md5 = S3FileLib::get_md5_from_s3(new_resource.bucket, nil, remote_path, new_resource.aws_access_key_id, new_resource.aws_secret_access_key, token)

    current_md5 = Digest::MD5.file(local_archive).hexdigest

    Chef::Log.debug "md5 of S3 object is #{s3_md5}"
    Chef::Log.debug "md5 of local object is #{current_md5}"

    if current_md5 == s3_md5
      Chef::Log.debug 'Skipping download, md5sum of local file matches file in S3.'
      download = false
    end
  end
  if download
    body = S3FileLib::get_from_s3(new_resource.bucket, nil, remote_path, new_resource.aws_access_key_id, new_resource.aws_secret_access_key, token).body

    local_file = file local_archive do
      owner new_resource.user if new_resource.user
      group new_resource.group if new_resource.group
      mode new_resource.mode if new_resource.mode
      action :nothing
      content body
    end
    local_file.run_action(:create)
  end
  # We have updated something if target directory needs to be recreated
  updated = overwrite and ::File.exists?(new_resource.creates)
  potd_exec = execute "purge old target dir" do
    command "rm -rf #{new_resource.target_dir}/*"
    action :nothing
    only_if { overwrite and ::File.exists? new_resource.creates }
  end
  potd_exec.run_action(:run)

  # We have updated something if the directory was recreated
  updated = (updated or (overwrite and !::File.exists?(new_resource.creates)))
  target_dir = directory new_resource.target_dir do
    owner new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    action :nothing
  end
  target_dir.run_action(:create)

  updated = (updated or overwrite) # Pedantic value only ... we know by now
  eb_exec = execute "extract #{basename}" do
    command "tar xf #{download_dir}/#{basename} #{new_resource.tar_flags ? new_resource.tar_flags.join(' ') : ''}"
    cwd new_resource.target_dir
    user new_resource.user
    group new_resource.group
    only_if { overwrite or updated }
    action :nothing # We will force run ourselves
  end
  eb_exec.run_action(:run)

  new_resource.updated_by_last_action(updated)
end
