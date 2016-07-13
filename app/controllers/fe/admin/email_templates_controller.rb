class Fe::Admin::EmailTemplatesController < ApplicationController
  before_filter :check_valid_user

  def index
    @email_templates = Fe::EmailTemplate.order('name')
  end

  def new
    @email_template = Fe::EmailTemplate.new

  end

  def edit
    @email_template = Fe::EmailTemplate.find(params[:id])
  end

  def create
    @email_template = Fe::EmailTemplate.new(email_template_params)

    if @email_template.save
    #  format.html { redirect_to fe_admin_email_templates_path }
    else
    #  format.html { render :action => :new }
    end
  end

  def update
    @email_template = Fe::EmailTemplate.find(params[:id])

    if @email_template.update_attributes(email_template_params)
      format.html { redirect_to fe_admin_email_templates_path }
    else
      format.html { render :action => "edit" }
    end
  end

  def destroy
    @email_template = Fe::EmailTemplate.find(params[:id])
    @email_template.destroy

  #    format.html { redirect_to fe_admin_email_templates_path }
  end

  protected

    def email_template_params
      params.require(:email_template).permit(:name, :subject, :content)
    end
end
