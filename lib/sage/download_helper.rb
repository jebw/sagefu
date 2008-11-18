module Sage
  
  module DownloadHelper
  
    def download_xml(options = {}, &block)
      
      xml = options[:xml] || eval("xml", block.binding)
      xml.instruct!
      
      xml.Company do    
        yield DownloadXmlBuilder.new(xml, self, options)
      end
      
    end
    
    class DownloadXmlBuilder
      
      def initialize(xml, view, xml_options)
        @xml, @view, @xml_options = xml, view, xml_options
      end
      
      private
        
        def method_missing(method, *arguments, &block)
          @xml.__send__(method, *arguments, &block)
        end
      
    end

  end

end
