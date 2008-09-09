require 'rexml/document'
include REXML

module Sage

  class UploadXml
  
    def initialize(uploaded_xml)
      @xml = Document.new(uploaded_xml)
    end
  
    def products
      @xml.elements.each('Company/Products/Product') do |p|
				additional = Hash.new
        sku = p.elements['Sku'].text
        price = p.elements['SalePrice'].text.to_f
        name = p.elements['Name'].text
        desc = p.elements['Description'].text
				ldesc = p.elements['LongDescription'].text
				weight = p.elements['UnitWeight'].text.to_i
				stock = p.elements['QtyInStock'].text.to_i
				group_code = p.elements['GroupCode'].text.to_i
				publish = (p.elements['Publish'].text.downcase == 'true')

				additional[:custom1] = p.elements['Custom1'].text
				additional[:custom2] = p.elements['Custom2'].text
				additional[:custom3] = p.elements['Custom3'].text
				additional[:on_order] = p.elements['QtyOnOrder'].text.to_i
				additional[:reorder_qty] = p.elements['ReorderQty'].text.to_i
				additional[:tax_code] = p.elements['TaxCode'].text.to_i
				additional[:dept] = p.elements['Department'].text.to_i
				additional[:unit] = p.elements['UnitOfSale'].text.to_i
				additional[:nominal_code] = p.elements['NominalCode'].text.to_i
				additional[:special_offer] = (p.elements['SpecialOffer'].text.downcase == 'true')
				additional[:allocated] = p.elements['QtyAllocated'].text.to_i
				
        yield sku, name, price, desc, ldesc, weight, stock, group_code, publish, additional
      end    
    end
    
    def tax_codes
    end
    
    def groups
    end
  
  end

end
