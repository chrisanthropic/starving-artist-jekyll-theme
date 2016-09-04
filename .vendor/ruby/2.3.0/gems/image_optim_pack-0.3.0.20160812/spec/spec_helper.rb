RSpec.configure do |c|
  c.before do
    stub_const('ImageOptim::Config::GLOBAL_PATH', '/dev/null')
    stub_const('ImageOptim::Config::LOCAL_PATH', '/dev/null')
  end

  c.order = :random
end
