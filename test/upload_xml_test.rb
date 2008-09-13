require File.dirname(__FILE__) + '/../../../../test/test_helper'

class UploadXmlTest < Test::Unit::TestCase

  def test_uploading_products  
    ux = Sage::UploadXml.new(sample_xml)
    count = 0
    product = {}
    ux.products do |sku, name, price, desc, ldesc, weight, stock, group_code, publish, additional|
      count += 1
      product[:sku] = sku
      product[:name] = name
      product[:price] = price
      product[:desc] = desc
      product[:ldesc] = ldesc
      product[:weight] = weight
      product[:stock] = stock
      product[:group_code] = group_code
      product[:publish] = publish
      product[:additional] = additional
    end
    assert_equal 16, count
    assert_equal 'DVD-UNSG2', product[:sku]
    assert_equal 'Under Siege 2 - Dark Territory', product[:name]
    assert_equal 29.99, product[:price]
    assert_equal nil, product[:desc]
    assert !product[:ldesc].blank?
    assert_equal 7, product[:weight]
    assert_equal 0, product[:stock]
    assert_equal 1, product[:group_code]
    assert_equal false, product[:publish]
  end
  
protected

  def sample_xml
    File.read(File.join(File.dirname(__FILE__), 'fixtures', 'upload.xml'))
  end

end
