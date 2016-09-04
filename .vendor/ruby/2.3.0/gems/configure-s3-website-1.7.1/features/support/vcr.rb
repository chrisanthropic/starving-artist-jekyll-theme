require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'features/cassettes'
end

VCR.cucumber_tags do |t|
  t.tag '@bucket-does-not-exist'
  t.tag '@bucket-does-not-exist-in-tokyo'
  t.tag '@bucket-exists'
  t.tag '@redirects'
  t.tag '@create-cf-dist'
  t.tag '@apply-configs-on-cf-dist'
end
