# == Schema Information
#
# Table name: sms_logs
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  customer_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  warning_state :boolean
#

class SmsLog < ActiveRecord::Base
  belongs_to :customer

  def self.send_task_notification task
    members = task.try(:customer).try(:members)
    sended_users = members.group(:openid).pluck(:openid)

    text_message = "[上海气象局科科技服务中心]#{name}."
    task.customer.create(content: text_message)
    $group_client.message.send_text(sended_users, [], [], 1, text_message)
  end

  def self.check_task
    $redis.hgetall("task_log_cache").keys.each do |key|
      identifier, time = key.split("_")
      
      task = Task.find_by(identifier: identifier)
      next unless task.present?

      # 上一次上报的时间
      now_time = DateTime.now.to_i
      if (now_time - time.to_i)/60 > task.rate
        send_task_notification task
      end
    end
  end
end