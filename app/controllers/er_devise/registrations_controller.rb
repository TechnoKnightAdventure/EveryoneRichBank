class ErDevise::RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.role = "customer"
    resource.save
  end
end
