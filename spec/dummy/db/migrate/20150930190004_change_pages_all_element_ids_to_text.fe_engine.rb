# This migration comes from fe_engine (originally 20150928085325)
class ChangePagesAllElementIdsToText < ActiveRecord::Migration[4.2]
  def change
    change_column Fe::Page.table_name, :all_element_ids, :text
  end
end
