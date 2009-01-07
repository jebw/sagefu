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
      
      def invoices(invoices, custom_map = {})
        @xml.Invoices do
          unless invoices.empty?
            map = FieldMap.new(invoice, custom_map)
            
            map.find_field('Id')
            map.find_field('InvoiceNumber', true)
            
            invoices.each do |invoice|
              @xml.Invoice do
                map.write_values(@xml, invoice)
              end
            end
          end
        end
      end
      
      private
        
        def method_missing(method, *arguments, &block)
          @xml.__send__(method, *arguments, &block)
        end

    end
    
    class FieldMap < Hash
    
      def initialize(obj, map = {})
        super()
        @map_for = obj
        @map_for_methods = obj.methods
        map.each { |k,v| self[k] = v }
      end
      
      def find_field(field, required = false, alternatives = [])
        return if has_key?(field)
        
        needles = [ field, field.downcase, field.underscore ]
        needles += alternatives
        
        needles.each do |needle|
          if @map_for_methods.include?(needle)
            self[field] = needle.to_sym
            return
          end
        end
        
        if required
          raise InvalidFormatError
        else
          nil
        end
      end
      
      def write_values(xml, obj)
        each do |k, v|
          next if v.nil?
          
          if v.is_a?(Symbol)
            xml.__send__ k, obj.send(v)
          else
            xml.__send__ k, v
          end
        end
      end
      
    end
    
    class InvalidFormatError < RuntimeError
    end

  end

end
