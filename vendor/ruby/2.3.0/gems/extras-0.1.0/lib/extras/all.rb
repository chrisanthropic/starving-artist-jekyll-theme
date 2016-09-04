# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Dir[File.join(File.expand_path(__dir__), "{*,**/*}.rb")].each do |f|
  require f
end
