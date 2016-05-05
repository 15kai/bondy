class SurveyFormGenerator
  class SurveyFormBase
    include ActiveModel::Model
    cattr_accessor :survey

    def self.setup(survey)
      self.survey = survey

      survey.questions.each do |q|
        attr_name = answer_attr(q.id)
        attr_accessor attr_name

        case q.input_type
        when 'checkbox'
          validates attr_name, presence: true
          validate do
            value = send(attr_name)
            values = q.options.map(&:value)
            if value.is_a?(Array) && value.any?{ |v| !values.include?(v) }
              errors.add(attr_name, :invalid)
            end
          end
        when 'radio'
          validates attr_name, presence: true, inclusion: q.options.map(&:value)
        when 'text', 'textarea'
          validates attr_name, presence: true
        end

        set_other_input(q)
      end
    end

    def self.set_other_input(q)
      return unless q.other_input

      attr_name = answer_attr(q.id)
      other_input_attr_name = other_input_attr(q.id)

      attr_accessor other_input_attr_name
      validate do
        value = send(attr_name)
        if (value.is_a?(Array) && value.include?('その他')) || (value.is_a?(String) && value == 'その他')
          if send(other_input_attr_name).blank?
            errors.add(attr_name, :invalid)
          end
        end
      end
    end

    def self.answer_attr(id)
      "answer#{id}"
    end

    def self.other_input_attr(id)
      "#{answer_attr(id)}_other"
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
