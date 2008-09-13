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
  
  def test_uploading_product_groups
    ux = Sage::UploadXml.new(sample_xml)
    count = 0
    pgroup = {}
    ux.groups do |ref, name|
      count += 1
      pgroup[:ref] = ref
      pgroup[:name] = name
    end
    assert_equal 3, count
    assert_equal 3, pgroup[:ref]
    assert_equal 'Jebs', pgroup[:name]
  end
  
  def test_uploading_tax_rates
    ux = Sage::UploadXml.new(sample_xml)
    count = 0
    rates = {}
    ux.tax_rates do |ref, desc, rate|
      count += 1
      rates[:ref] = ref
      rates[:desc] = desc
      rates[:rate] = rate
    end
    assert_equal 9, count
    assert_equal 8, rates[:ref]
    assert_equal 'Standard rated purchases from suppliers in EC', rates[:desc]
    assert_equal 17.5, rates[:rate]
  end
  
  def test_uploading_customers
    ux = Sage::UploadXml.new(sample_xml)
    count = 0
    customer = {}
    ux.customers do |company, account_ref, invoice_addr, delivery_addr, vat_number, terms_agreed|
      count += 1
      customer[:company] = company
      customer[:account_ref] = account_ref
      customer[:invoice_addr] = invoice_addr
      customer[:delivery_addr] = delivery_addr
      customer[:vat_number] = vat_number
      customer[:terms_agreed] = terms_agreed
    end
    assert_equal 4, count
    assert_equal 'Ibex', customer[:company]
    assert_equal '75', customer[:account_ref]
    assert_equal 'jeremy', customer[:invoice_addr][:forename]
    assert_equal 'wilkins', customer[:invoice_addr][:surname]
    assert_equal 'Ibex', customer[:invoice_addr][:company]
    assert_equal 'Kendal', customer[:invoice_addr][:address1]
    assert_equal nil, customer[:invoice_addr][:address2]
    assert_equal 'Kendal', customer[:invoice_addr][:town]
    assert_equal 'la17 3nk', customer[:invoice_addr][:postcode]
    assert_equal 'foobar@email.com', customer[:invoice_addr][:email]
    assert_equal 'jeremy', customer[:delivery_addr][:forename]
    assert_equal 'wilkins', customer[:delivery_addr][:surname]
    assert_equal nil, customer[:vat_number]
    assert_equal nil, customer[:terms_agreed]
  end
  
protected

  def sample_xml
    File.read(File.join(File.dirname(__FILE__), 'fixtures', 'upload.xml'))
  end

end
