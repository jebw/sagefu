require 'rexml/document'
include REXML

module Sage

  class UploadXml
  
    def initialize(uploaded_xml)
      @xml = Document.new(uploaded_xml)
    end
  
    def products
      @xml.elements.each('Company/Products/Product') do |p|
        sku = p.elements['Sku'].text
        price = p.elements['SalePrice'].text
                
        yield sku, price
      end    
    end
    
    def tax_codes
    end
    
    def groups
    end
  
  end

end
