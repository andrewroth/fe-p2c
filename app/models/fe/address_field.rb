module Fe
  class AddressField < Question

    # css class names for javascript-based validation
    def validation_class(answer_sheet)
      validation = ''
      validation += ' required' if self.required?(answer_sheet)
      # validate-number, etc.
      validate_style = ['number', 'currency-dollar', 'email', 'url', 'phone'].find {|v| v == self.style }
      if validate_style
        validation += ' validate-' + validate_style
      end
      validation
    end

    # which view to render this element?
    def ptemplate
      "fe/address_field"
    end

  end
end
