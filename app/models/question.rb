class Question < ActiveYaml::Base
  set_filename 'src/questions'

  include ActiveHash::Associations
  belongs_to :survey
  has_many :options

  def as_json(opts = {})
    {
      id: id,
      text: text,
      input_type: input_type,
      options: options.as_json
    }
  end
end
