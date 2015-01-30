require 'active_record'
require 'active_record/base'

ACTIVE_RECORD_VERSION = ActiveRecord::VERSION

if ACTIVE_RECORD_VERSION::MAJOR < 4 || (ACTIVE_RECORD_VERSION::MAJOR == 4 && ACTIVE_RECORD_VERSION::MINOR <= 1)
  require 'activerecord_enum/activerecord_enum_pre42.rb'
else
  require 'activerecord_enum/activerecord_enum_post42.rb'
end