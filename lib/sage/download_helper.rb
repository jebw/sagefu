module Sage
  
  module DownloadHelper
  
    def download_xml(options = {}, &block)
      
      xml = options[:xml] || eval("xml", block.binding)
      xml.instruct!
      
      xml.Company("xmlns:xsd" => "http://www.w3.org/2001/XMLSchema", 
                  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance") do    
        yield DownloadXmlBuilder.new(xml, self, options)
      end
      
    end
    
    class DownloadXmlBuilder
      
      def initialize(xml, view, xml_options)
        @xml, @view, @xml_options = xml, view, xml_options
      end
      
      def customer(cust)
        @xml.Customer do
          @xml.CompanyName(cust.Company) if cust.methods.include?('Company')
          @xml.CompanyName(cust.company) if cust.methods.include?('company')
          @xml.CompanyName(cust.CompanyName) if cust.methods.include?('CompanyName')
          @xml.CompanyName(cust.company_name) if cust.methods.include?('company_name')
        end
      end
      
      def invoices(invoices)
        @xml.Invoices do
          map = build_invoice_map(invoices.first) unless invoices.empty?
        
          invoices.each do |invoice|
            @xml.Invoice do
              map.each do |key, value|
                @xml.__send__ key, invoice.send(value) unless value.nil?
              end
            end
          end
        end
      end
      
      private
        
        def method_missing(method, *arguments, &block)
          @xml.__send__(method, *arguments, &block)
        end
      
        def build_invoice_map(invoice)
          map = Hash.new
          im = invoice.methods
          
          map['Id'] = first_match(im, ['Id', 'id'])
          map['InvoiceNumber'] = first_match(im, ['InvoiceNumber', 'invoicenumber', 'invoice_number'])
          
          map
        end
        
        def first_match(haystack, needles)
          needles.each do |needle|
            return needle if haystack.include?(needle)
          end
          
          nil
        end
    end

  end

end
