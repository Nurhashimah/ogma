ActionMailer::Base.smtp_settings = {
  :address              => "smtp.mail.yahoo.com",
  :port                 => 587,
  :domain               => "yahoo.com",
  :user_name            => "pustakabistari_kskbjb@yahoo.com",
  :password             => "kskbjb8173",
  :authentication       => :plain,
  :enable_starttls_auto => true
}
