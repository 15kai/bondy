class Option < ActiveYaml::Base
  set_filename 'src/options'

  include ActiveHash::Associations
  belongs_to :question

  def other_input?
    question.other_input && value == 'その他'
  end

  def as_json(opt = {})
    {
      id: id,
      value: value
    }
  end
end
