module PollNotificationEvent
  #TODO: there are some discussion dependencies that will need to be resolved here

  def poll
    eventable.poll
  end

  private

  def notification_recipients
    if announcement
      announcement_notification_recipients
    else
      specified_notification_recipients
    end
  end

  def announcement_notification_recipients
    poll.group.members
  end

  def specified_notification_recipients
    Queries::UsersToMentionQuery.for(poll)
  end

  def email_recipients
    if announcement
      announcement_email_recipients
    else
      specified_email_recipients
    end
  end

  def announcement_email_recipients
    Queries::UsersByVolumeQuery.normal_or_loud(poll.discussion)
  end

  def specified_email_recipients
    notification_recipients.where(email_when_mentioned: true)
  end

  def notification_translation_values
    super.merge(poll_type: I18n.t(:"poll_types.#{poll.poll_type}").downcase)
  end

  def mailer
    PollMailer
  end
end