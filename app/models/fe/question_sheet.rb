# QuestionSheet represents a particular form
module Fe
  class QuestionSheet < ActiveRecord::Base
    self.table_name = self.table_name.sub('fe_', Fe.table_name_prefix)

    has_many :pages, -> { order('number') },
             :dependent => :destroy

    # has_many :elements
    # has_many :questions

    has_many :answer_sheet_question_sheets

    has_many :answer_sheets,
             :through => :answer_sheet_question_sheets
    has_many :question_sheets,
             :through => :answer_sheet_question_sheets

    scope :active, -> { where(:archived => false) }
    scope :archived, -> { where(:archived => true) }

    validates_presence_of :label
    #  validates_length_of :label, :maximum => 60, :allow_nil => true
    validates_uniqueness_of :label

    before_destroy :check_for_answers

    # create a new form with a page already attached
    def self.new_with_page
      question_sheet = self.new(:label => next_label)
      question_sheet.pages.build(:label => 'Page 1', :number => 1)
      question_sheet
    end

    # count all questions including ones inside a grid
    def questions_count
      all_elements.questions.count
    end

    # returns all elements including ones inside a grid
    def elements
      pages.collect(&:elements).flatten
    end

    def all_elements
      element_ids = pages.pluck(:all_element_ids).join(',').split(',')
      element_ids << 0 # in case there are no elements, the query breaks at IN ()
      Element.where(id: element_ids.split(','))
    end

    # Pages get duplicated
    # Question elements get associated
    # non-question elements get cloned
    def duplicate
      new_sheet = QuestionSheet.new(self.attributes.merge(id: nil))
      new_sheet.label = self.label + ' - COPY'
      new_sheet.save(:validate => false)
      self.pages.each do |page|
        page.copy_to(new_sheet)
      end
      new_sheet
    end

    # pages hidden by a conditional element
    def hidden_pages(answer_sheet)
      all_elements.where(conditional_type: 'Fe::Page').find_all{ |e| 
        !e.conditional_match(answer_sheet)
      }.collect(&:conditional)
    end

    private

    # next unused label with "Untitled form" prefix
    def self.next_label
      Fe.next_label("Untitled form", untitled_labels)
    end

    # returns a list of existing Untitled forms
    # (having a separate method makes it easy to mock in the spec)
    def self.untitled_labels
      QuestionSheet.where("label LIKE ?", 'Untitled form%').map{|s| s.label }
    end

    def check_for_answers

    end

  end
end
