class Option < ActiveYaml::Base
  set_filename 'src/options'

  include ActiveHash::Associations
  belongs_to :question

  def as_json(opt = {})
    {
      id: id,
      value: value
    }
  end
end
