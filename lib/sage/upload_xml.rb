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
    
    def tax_rates
			@xml.elements.each('Company/TaxRates/TaxRate') do |tr|
				ref = tr.elements['Reference'].text.to_i
				desc = tr.elements['Description'].text
				rate = tr.elements['Rate'].text.to_f
				
				yield ref, desc, rate
			end
    end
    
    def groups
			@xml.elements.each('Company/ProductGroups/ProductGroup') do |pg|
				ref = pg.elements['Reference'].text.to_i
				name = pg.elements['Name'].text
				
				yield ref, name
			end
    end

		def customers
			@xml.elements.each('Company/Customers/Customer') do |c|
				company = c.elements['CompanyName'].text
				account_ref = c.elements['AccountReference'].text
				vat_number = c.elements['VatNumber'].text
				terms_agreed = c.elements['TermsAgreed'] ? (c.elements['TermsAgreed'].text.downcase == 'true') : nil
				invoice_addr = Hash.new
				delivery_addr = Hash.new
				
				c.elements.each('CustomerInvoiceAddress') do |a|
					invoice_addr[:title] = a.elements['Title'].text
					invoice_addr[:forename] = a.elements['Forename'].text
					invoice_addr[:surname] = a.elements['Surname'].text
					invoice_addr[:company] = a.elements['Company'].text
					invoice_addr[:address1] = a.elements['Address1'].text
					invoice_addr[:address2] = a.elements['Address2'].text
					invoice_addr[:address3] = a.elements['Address3'].text
					invoice_addr[:town] = a.elements['Town'].text
					invoice_addr[:postcode] = a.elements['Postcode'].text
					invoice_addr[:county] = a.elements['County'].text
					invoice_addr[:country] = a.elements['Country'].text
					invoice_addr[:telephone] = a.elements['Telephone'].text
					invoice_addr[:fax] = a.elements['Fax'].text
					invoice_addr[:mobile] = a.elements['Mobile'].text
					invoice_addr[:email] = a.elements['Email'].text
				end
				
				c.elements.each('CustomerDeliveryAddress') do |a|
					delivery_addr[:title] = a.elements['Title'].text
					delivery_addr[:forename] = a.elements['Forename'].text
					delivery_addr[:surname] = a.elements['Surname'].text
					delivery_addr[:company] = a.elements['Company'].text
					delivery_addr[:address1] = a.elements['Address1'].text
					delivery_addr[:address2] = a.elements['Address2'].text
					delivery_addr[:address3] = a.elements['Address3'].text
					delivery_addr[:town] = a.elements['Town'].text
					delivery_addr[:postcode] = a.elements['Postcode'].text
					delivery_addr[:county] = a.elements['County'].text
					delivery_addr[:country] = a.elements['Country'].text
					delivery_addr[:telephone] = a.elements['Telephone'].text
					delivery_addr[:fax] = a.elements['Fax'].text
					delivery_addr[:mobile] = a.elements['Mobile'].text
					delivery_addr[:email] = a.elements['Email'].text
				end
				
				yield company, account_ref, invoice_addr, delivery_addr, vat_number, terms_agreed
			end
		end
  
  end

end
