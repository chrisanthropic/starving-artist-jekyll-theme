require 'rspec'

When /^I run the configure-s3-website command with parameters$/ do |table|
  options, optparse = ConfigureS3Website::CLI.optparse_and_options
  optparse.parse! args_array_from_cucumber_table(table)
  @config_source = options[:config_source]
  @headless = options[:headless]
  @autocreate_cloudfront_dist = options[:autocreate_cloudfront_dist]
  @reset = create_reset_config_file_function @config_source.description
  @console_output = capture_stdout {
    ConfigureS3Website::Runner.run(options, stub_stdin)
  }
end

Given /^I answer 'yes' to 'do you want to use CloudFront'$/ do
  @first_stdin_answer = 'y'
end

Then /^the output should be$/ do |expected_console_output|
  @console_output.should eq(expected_console_output)
end

Then /^the output should include$/ do |expected_console_output|
  @console_output.should include(expected_console_output)
end

Then /^the config file should contain the distribution id$/ do
  config_file_path = @config_source.description
  File.open(config_file_path, 'r').read.should include(
    "cloudfront_distribution_id: #{@config_source.cloudfront_distribution_id}"
  )
end

def args_array_from_cucumber_table(table)
  args = []
  table.hashes.map do |entry|
    { entry[:option] => entry[:value] }
  end.each do |opt|
    args << opt.keys.first
    args << opt.values.first if opt.values.first
  end
  args
end

def stub_stdin
  stdin = stub('std_in')
  stdin.stub(:gets).and_return {
    first_stdin_answer
  }
  stdin
end

# A function for bringing back the original config file
# (in case we modified it during the test)
def create_reset_config_file_function(yaml_file_path)
  original_contents = File.open(yaml_file_path, 'r').read
  -> {
    File.open(yaml_file_path, 'w') { |yaml_file|
      yaml_file.puts(original_contents)
    }
  }
end

# The first prompt asks "do you want to create a CloudFront distro"
def first_stdin_answer
  @first_stdin_answer || 'n'
end

module Kernel
  require 'stringio'

  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    out.string
  ensure
    $stdout = STDOUT
  end
end
