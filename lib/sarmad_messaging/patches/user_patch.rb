require_dependency 'user'
module SarmadMessaging
  module Patches
    module UserPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          include Mailboxer::Models::Messageable
        end
      end

      module ClassMethods

      end

      module InstanceMethods
        def mailboxer_email(object)
          nil
        end
      end
    end
  end
end

unless User.included_modules.include?(SarmadMessaging::Patches::UserPatch)
  User.send(:include, SarmadMessaging::Patches::UserPatch)
end

Mailboxer::Receipt.class_eval do
  attr_accessible :receiver, :mailbox_type
end
