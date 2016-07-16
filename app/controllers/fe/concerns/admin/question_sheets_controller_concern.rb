module Fe::Admin::QuestionSheetsControllerConcern
  extend ActiveSupport::Concern

  begin
    included do
      before_filter :check_valid_user
      before_filter :get_question_sheet, :only => [:show, :archive, :unarchive, :destroy, :edit, :update, :duplicate]
    end
  rescue ActiveSupport::Concern::MultipleIncludedBlocks
  end

  # list of all questionnaires/forms to edit
  # GET /question_sheets
  def index
    @active_question_sheets = Fe::QuestionSheet.active.order('label')
    @archived_question_sheets = Fe::QuestionSheet.archived.order('label')

    render json: { active: @active_question_sheets, archived: @archived_question_sheets }
  end

  def archive
    @question_sheet.update_attribute(:archived, true)
    render nothing: true
  end

  def unarchive
    @question_sheet.update_attribute(:archived, false)
    render nothing: true
  end

  def duplicate
    new_question_sheet = @question_sheet.duplicate
    render json: new_question_sheet
  end

  # GET /question_sheets/1
  def show
    render json: @question_sheet
  end

  # create sheet with inital page, redirect to show
  # POST /question_sheets
  def create
    @question_sheet = Fe::QuestionSheet.new_with_page

#    respond_to do |format|
#      if @question_sheet.save
#        format.html { redirect_to fe_admin_question_sheet_path(@question_sheet) }
#        format.xml  { head :created, :location => admin_question_sheet_path(@question_sheet) }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @question_sheet.errors.to_xml }
#      end
#    end
  end


  # display sheet properties panel
  # GET /question_sheets/1/edit
  def edit

#    respond_to do |format|
#      format.js
#    end
  end

  # save changes to properties panel (label, language)
  # PUT /question_sheets/1
  def update
    params.require(:fe_question_sheet).permit!

#    respond_to do |format|
#      if @question_sheet.update_attributes(params[:fe_question_sheet])
#        format.html { redirect_to fe_admin_question_sheet_path(@question_sheet) }
#        format.js
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.js { render :action => "error.rjs"}
#        format.xml  { render :xml => @question_sheet.errors.to_xml }
#      end
#    end
  end

  # mark sheet as destroyed
  # DELETE /question_sheets/1
  def destroy
    @question_sheet.destroy

#    respond_to do |format|
#      format.html { redirect_to fe_admin_question_sheets_path }
#      format.xml  { head :ok }
#    end
  end

  protected
  def get_question_sheet
    @question_sheet = Fe::QuestionSheet.find(params[:id])
  end
end