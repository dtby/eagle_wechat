class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_customer

  def current_customer
    # Customer.first
    code = params[:code]
		logger.warn '-----------------------------------------'
		logger.warn code
		logger.warn '-----------------------------------------'
		result = $group_client.oauth.get_user_info(code, "1")

		openid = result.result["UserId"]
		session[:openid] = openid
    # openid = session[:openid]
    # customer = nil
    # if openid.blank?
    #   customer = Customer.first
    # else
    #   member = Member.where(openid: openid).first
    #   customer = member.try(:customer) || Customer.first
    # end
    # if customer.present?
    #   return customer
    # else
    #   return Customer.first
    # end
  end
end
