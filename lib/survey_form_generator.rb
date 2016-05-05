class SurveyFormGenerator
  class SurveyFormBase
    include ActiveModel::Model
    cattr_accessor :survey

    # TODO
    # params.permit的な奴

    def self.setup(survey)
      self.survey = survey

      survey.questions.each do |q|
        attr_name = answer_attr(q.id)
        attr_accessor attr_name
        if q.input_type == 'checkbox'
          validates attr_name, presence: true
          validate do
            value = send(attr_name)
            values = q.options.map(&:value)
            if value.is_a?(Array) && value.any?{ |v| !values.include?(v) }
              errors.add(attr_name, :invalid)
            end
          end
        elsif q.input_type == 'radio'
          validates attr_name, presence: true, inclusion: q.options.map(&:value)
        end
      end
    end

    def self.answer_attr(id)
      "answer#{id}"
    end

    def inputs
      self.class.survey.questions.map do |q|
        {
            question: q.text,
            answer: send(self.class.answer_attr(q.id))
        }
      end
    end
  end

  def self.generate(survey)
    return classes[survey.id] if Rails.env.production? && classes[survey.id]

    class_name = "SurveyForm#{survey.id}"
    classes[survey.id] = Object.const_set(class_name, Class.new(SurveyFormBase) { setup survey })
  end

  def self.classes
    @classes ||= {}
  end
end
