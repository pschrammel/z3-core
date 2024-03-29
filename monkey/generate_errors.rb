#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'ostruct'
require 'erb'

error_filename = File.join(File.dirname(__FILE__), "error.xml")
xml= Nokogiri.parse(File.read(error_filename))

errors=[]
xml.xpath("//tr").each do |row|
  error=OpenStruct.new
  col=0
  row.xpath("td").each do |column|
    txt=column.text.strip
    case col
      when 0
        error.class_name = txt
      when 1
        error.description = txt
      when 2
        error.code = txt.to_i
      when 3
        error.soap = txt
    end
    #p txt
    #puts "-----#{col}------"
    col += 1

  end

  errors << error
end

template="
class Z3::Errors::<%= error.class_name %> < Z3::Error
  def http_status_code
    <%= error.code %>
  end

  def message
    %q{<%= error.description %>}
  end
end

"
file="# DON't touch ! this file is auto generated by monkey/generate_errors.rb\n\nmodule Z3::Errors; end\n"
errors.each do |error|
  file << ERB.new(template).result(binding)  if error.code
end


puts file