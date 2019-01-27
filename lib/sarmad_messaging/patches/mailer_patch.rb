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
            begin
              body = Nokogiri::HTML(m.html_part.body.to_s).css('body').inner_html
            rescue
              body = m.text_part.body
            end
            if body && email && subject
              admin = User.where(admin: true).first
              if email.is_a?(Array)
                email.each do |e|
                  if e.is_a?(User)
                    receiver = e
                    if receiver && admin
                      admin.send_message(receiver, body.to_s, subject)
                    end
                  else
                    receiver = User.find_by_mail(e)
                    if receiver && admin
                      admin.send_message(receiver, body.to_s, subject)
                    end
                  end
                end
              else
                if email.is_a?(User)
                  receiver = email
                  if receiver && admin
                    admin.send_message(receiver, body.to_s, subject)
                  end
                else
                  receiver = User.find_by_mail(email)
                  if receiver && admin
                    admin.send_message(receiver, body.to_s, subject)
                  end
                end
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