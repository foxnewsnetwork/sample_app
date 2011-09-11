class User < ActiveRecord::Base
  attr_accessible :username, :email
  
  email_regex = /\A[a-zA-Z0-9_.-]{1,}@[a-zA-Z0-9_.-]{1,}\.[a-zA-Z]{2,}\z/i
  validates :username , :presence => true ,
                        :length => { :maximum => 64 }
  validates :email , :presence => true ,
                     :format => { :with => email_regex } ,
                     :uniqueness => { :case_sensitive => false }
end
