require 'spec_helper'

describe Book do
  
  subject { Book.new }
  
  it { should have_attached_file(:file) }
  it { should validate_attachment_presence(:file) }
  it { should validate_attachment_content_type(:file).allowing('application/pdf').rejecting('text/plain', 'text/xml') }
  it { should validate_attachment_size(:file).less_than(7.megabytes) }
  
  it { should belong_to :author}
  
end
