class SkillsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @skills = policy_scope(Skill)
  end

  def show
    @skill = Skill.find(params[:id])
    @user_skills = @skill.user_skills
    @user_skills.each do |skill|
      p skill.user
    end
  end
end
