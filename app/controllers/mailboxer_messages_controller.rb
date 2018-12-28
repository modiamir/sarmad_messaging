class MailboxerMessagesController  < ApplicationController
  before_action :authorize, :except => [:index]

  def index
    scope = User.current.mailbox.inbox

    @messages_count = scope.count
    @messages_pages = Paginator.new @messages_count, 5, 1
    @offset ||= @messages_pages.offset
    @messages = scope.
      order("mailboxer_conversations.created_at DESC").
      limit(@limit).
      offset(@offset).
      to_a
  end
end
