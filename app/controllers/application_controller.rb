class ApplicationController < ActionController::Base
  rescue_from AASM::InvalidTransition, with: :failed_transition

  def failed_transition
    head :unprocessable_entity
  end
end
