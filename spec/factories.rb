FactoryGirl.define do 
  factory :user do 
    name                  "Chris A"
    email                 "biodieselchris@gmail.com"
    system                1
    init_reading          1890
    password              "foobarfoobar"
    password_confirmation "foobarfoobar"
  end
end