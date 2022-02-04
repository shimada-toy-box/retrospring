class Smile < ApplicationRecord
  belongs_to :user
  belongs_to :answer
  validates :user_id, presence: true, uniqueness: { scope: :answer_id, message: "already smiled answer" }
  validates :answer_id, presence: true

  # rubocop:disable Rails/SkipsModelValidations
  after_create do
    Notification.notify answer.user, self unless answer.user == user
    user.increment! :smiled_count
    answer.increment! :smile_count
  end

  before_destroy do
    Notification.denotify answer.user, self unless answer.user == user
    user&.decrement! :smiled_count
    answer&.decrement! :smile_count
  end
  # rubocop:enable Rails/SkipsModelValidations

  def notification_type(*_args)
    Notifications::Smiled
  end
end
