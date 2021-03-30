class ContactsController < ApplicationController

  # GET request for entering form info
  def new
    @contact = Contact.new
  end

  # POST request for storing Contact in db
  def create
    # Assign several vars at once with contact_params helper
    @contact = Contact.new(contact_params)

    # Try saving to db & store flash message to confirm success to user
    if @contact.save
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]

      ContactMailer.contact_email(name, email, body).deliver
      flash[:success] = "Message sent."
    else
      flash[:danger] = @contact.errors.full_messages.join(", ")
    end

    redirect_to new_contact_path
  end

  private
    # To collect form data, do the following to whitelist the form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end
