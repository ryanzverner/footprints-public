require 'warehouse/api_wrapper'
require 'warehouse/token_http_client'
require 'warehouse/json_api'
require 'warehouse/employment_post'

class ApplicantInteractor

  def initialize(applicant, params, id_token = nil)
    @applicant = applicant
    @params    = parse(params)
    @api       = setup_warehouse_api(WAREHOUSE_URL, id_token)
  end

  def parse(params)
    params[:archived] = params[:archived] == "on"
    params
  end

  def update
    @applicant.assign_attributes(@params)
    if @applicant.valid?
      notify_if_craftsman_changed
      send_to_warehouse_if_hired
    end
    @applicant.save!
  end

  def update_applicant_for_hiring
    @params.merge!(decision_made_on: Date.today, hired: "yes")
    update
  end

  def update_state
    @applicant.update_attributes!(@params)
  end

  def notify_if_craftsman_changed
    if craftsman_changed?
      @applicant.has_steward ? handle_transfer : send_request_email
    end
  end

  def craftsman_changed?
    @params[:assigned_craftsman] != "" && @applicant.assigned_craftsman_changed?
  end

  def handle_transfer
    send_transfer_emails
    @notice = get_notice + " Emailed #{@applicant.assigned_craftsman}."
  end

  def send_request_email
    craftsman = Craftsman.find_by_name(@applicant.assigned_craftsman)
    NotificationMailer.applicant_request(craftsman, @applicant).deliver
  end

  def send_transfer_emails
    previous_craftsman = @applicant.craftsman
    new_craftsman = Craftsman.find_by_name(@params[:assigned_craftsman])
    NotificationMailer.prev_craftsman_transfer(previous_craftsman, new_craftsman, @applicant).deliver
    NotificationMailer.new_craftsman_transfer(previous_craftsman, new_craftsman, @applicant).deliver
  end

  def send_to_warehouse_if_hired
    begin
      if @applicant.hired? && @applicant.hired_changed?
        if @applicant.resident?
          @api.add_resident!(@applicant)
        elsif @applicant.student?
          @api.add_student!(@applicant)
        end
        NotificationMailer.applicant_hired(@applicant).deliver
        Rails.logger.info "Warehouse post successful"
      end
    rescue StandardError => e
      Rails.logger.info "Warehouse could not be reached. #{e.try(:errors) || e}"
    end
  end

  def get_notice
    @notice ||= "Successfully updated applicant."
  end

  private

  def setup_warehouse_api(host, id_token)
    client = Warehouse::TokenHttpClient.new(:host => host, :id_token => id_token)
    warehouse_api = Warehouse::JsonAPI.new(client)
    Warehouse::EmploymentPost.new(warehouse_api)
  end
end
