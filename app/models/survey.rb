class Survey < ActiveYaml::Base
  set_filename 'src/surveys'

  include ActiveHash::Associations
  has_many :questions

  def as_json(ops = {})
    {
      id: id,
      title: title,
      questions: questions.as_json
    }
  end
end
