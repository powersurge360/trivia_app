class ApplicationController < ActionController::Base
  default_form_builder TailwindBuilder
  rescue_from AASM::InvalidTransition, with: :failed_transition

  def failed_transition
    head :unprocessable_entity
  end
end
