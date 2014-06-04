s3_archive Cookbook
===================

LWRP to download and extract archives from Amazon's Simple Storage Service.

e.g.
This cookbook makes your favorite breakfast sandwich.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - s3_archive needs toaster to brown your bagel.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### s3_archive::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['s3_archive']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### s3_archive::default

e.g.
Just include `s3_archive` in your node's `run_list`:

    json
    {
      "name":"my_node",
      "run_list": [
        "recipe[s3_archive]"
      ]
    }
    
Then the LWRP s3_archive can be used to pull an archive from S3
    
    s3_archive "archive_name.tar.gz" do
      remote_path "/path/to/archive"
      bucket "s3_bucket_name"
      aws_access_key_id "aws access key"
      aws_secret_access_key "aws secret key"
      owner "user to own extracted archive"
      group "group to own extracted archive"
      mode "permissions of downloaded archive"
      tar_flags "flags to pass to tar"
      target_dir "directory in which to extract archive"
      creates "file created by extraction to test for"
      download_dir "local staging directory (defaults to /tmp)"
      override "whether or not to override local directory when remote archive changes"
    end
        

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Gabriel Rosendorf - gabriel.rosendorf@weather.com
