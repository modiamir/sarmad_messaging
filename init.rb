require_dependency 'sarmad_messaging/sarmad_messaging'
Redmine::Plugin.register :sarmad_messaging do
  name 'پلاگین پیامرسان سرمد'
  author 'SarmadBS'
  description ''
  version '0.9.0'
  url 'http://sarmadbs.com'
  author_url 'mailto:plugin@satrapp.com'

  Redmine::MenuManager.map :account_menu do |menu|
    menu.push(:messages, { controller: 'mailboxer_messages', action: 'index' },
              param: :messages,
              caption: :messages,
              if: proc { !User.current.is_a?(AnonymousUser) })
  end
end
