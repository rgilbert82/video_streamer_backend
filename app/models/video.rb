class Video < ApplicationRecord
  belongs_to :channel
  has_many   :chats, dependent: :destroy
  validates_presence_of :title

  # Stats methods

  def get_video_age
    video_time = Time.parse(self.published_at)
    ((Time.now - video_time) / 3600).round
  end

  def get_stream_age
    if get_total_comments > 0
      comment = self.chats.first.comments.order('created_at').first
      first   = Time.parse(comment.published_at)
      ((Time.now - first) / 3600).round
    else
      ((Time.now - self.created_at) / 3600).round
    end
  end

  def get_total_comments
    chat = self.chats.first
    if chat
      chat.comments.count
    else
      0
    end
  end

  def get_comments_per_hour
    chat  = self.chats.first
    total = get_total_comments

    if total > 0
      comments = chat.comments.order('created_at')
      earliest = Time.parse(comments.first.published_at)
      latest   = Time.parse(comments.last.published_at)
      hours    = (latest - earliest) / 3600
      (total / hours).round(2)
    else
      0
    end
  end
end
