require_dependency 'sarmad_messaging/sarmad_messaging'
Redmine::Plugin.register :sarmad_messaging do
  name 'Sarmad Messaging plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  Redmine::MenuManager.map :account_menu do |menu|
    menu.push(:messages, { controller: 'mailboxer_messages', action: 'index' },
              param: :messages,
              caption: :messages,
              if: proc { !User.current.is_a?(AnonymousUser) })
  end
end
