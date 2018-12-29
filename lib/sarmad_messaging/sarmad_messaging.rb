Rails.configuration.to_prepare do
  require 'sarmad_messaging/patches/user_patch'
  require 'sarmad_messaging/patches/mailer_patch'
end

Mail.eager_autoload!
