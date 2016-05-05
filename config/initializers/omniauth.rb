Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
           ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :facebook,
           ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
           scope: 'email',
           info_fields: 'name, first_name, last_name, email, locale, gender, age_range, location, work'

end
