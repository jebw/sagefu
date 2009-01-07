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
      
      def invoices(invoices, map = {})
        @xml.Invoices do
          map = build_invoice_map(invoices.first, map) unless invoices.empty?
        
          invoices.each do |invoice|
            @xml.Invoice do
              map.each do |key, value|
                next if value.nil?
                
                if value.is_a?(Symbol)
                  @xml.__send__ key, invoice.send(value) unless value.nil?
                else
                  @xml.__send__ key, value
                end
              end
            end
          end
        end
      end
      
      private
        
        def method_missing(method, *arguments, &block)
          @xml.__send__(method, *arguments, &block)
        end
      
        def build_invoice_map(invoice, map)
          im = invoice.methods
          
          find_field(map, im, 'Id')
          find_field(map, im, 'InvoiceNumber', true)
          
          map
        end
        
        def find_field(map, haystack, field, required = false, alternatives = [])
          return if map.keys.include?(field)
        
          needles = [ field, field.downcase, field.underscore ]
          needles += alternatives
        
          needles.each do |needle|
            if haystack.include?(needle)
              map[field] = needle.to_sym
              return
            end
          end
          
          if required
            raise InvalidFormatError
          else
            nil
          end
        end
    end
    
    class InvalidFormatError < RuntimeError
    end

  end

end
