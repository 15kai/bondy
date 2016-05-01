require 'survey_form_generator'

class SurveysController < ApplicationController
  def show
    @survey = Survey.find(params[:id])
    @form = SurveyFormGenerator.generate(@survey).new
  end

  def create
    render json: params.as_json
  end
end
