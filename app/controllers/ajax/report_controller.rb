class Ajax::ReportController < ApplicationController
  def create
    params.require :id
    params.require :type

    @status = :err
    @success = false

    if current_user.nil?
      @message = "login required"
      return
    end

    unless %w(answer comment question user).include? params[:type]
      @message = "unknown type"
      return
    end

    object = params[:type].strip.capitalize.constantize.find params[:id]

    if object.nil?
      @message = "Could not find #{params[:type]}"
      return
    end

    current_user.report object

    @status = :okay
    @message = "#{params[:type].capitalize} reported.  A moderator will decide what happens with the #{params[:type]}."
    @success = true
  end
end
