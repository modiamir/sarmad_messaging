require_dependency 'user'
module SarmadMessaging
  module Patches
    module MailerPatch

      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :mail, :sarmad_messaging
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def mail_with_sarmad_messaging(headers, &block)
          subject = email = nil
          begin
            subject = headers[:subject]
            email = headers[:to]
          rescue
          end
          m = mail_without_sarmad_messaging(headers, &block)
          begin
            body = m.text_part.body
            if body && email && subject
              admin = User.where(admin: true).first
              receiver = User.find_by_mail(email)
              if receiver && admin
                admin.send_message(receiver, body.to_s, subject)
              end
            end
          rescue
          end
        end
      end
    end
  end
end

unless Mailer.included_modules.include?(SarmadMessaging::Patches::MailerPatch)
  Mailer.send(:include, SarmadMessaging::Patches::MailerPatch)
end