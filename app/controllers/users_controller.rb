class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
    @user.save
      @user.points += 10
    end
  end

  def update
    @user_description = current_user
    @user.description = params[:description] || params[:user][:description]
    @user_skill.save
    authorize @user.description
    if @user_description.save!
      redirect_to dashboard_path
    else
      render
    end
  end
end


# def create
#   @user_skill = UserSkill.find(params[:user_skill_id])
#   @skill = @user_skill.skill.name
#   @booking = Booking.new(booking_params)
#   @booking.user_skill = @user_skill
#   @booking.skill = @skill
#   @booking.status = 'Pending'
#   @booking.student = current_user
#   @booking.teacher = @user_skill.user
#   @booking.remote = params[:booking][:remote] == '0' ? false : true
#   authorize @booking
#   if @booking.save
#     if @booking.student.points >= 10
#       @booking.student.points -= 10
#       @booking.student.save
#       @chatroom = Chatroom.where(teacher: @booking.teacher.id, student: @booking.student.id).or(Chatroom.where(teacher: @booking.student.id, student: @booking.teacher.id))
#       if !@chatroom.present?
#         @chatroom = Chatroom.create(student: current_user, teacher: @booking.teacher)
#         redirect_to chatroom_path(@chatroom, chat: @chatroom.id), alert: "Your booking request has been sent"
#       else
#         @chatroom
#         redirect_to chatroom_path(@chatroom, chat: @chatroom.ids.first), alert: "Your booking request has been sent"
#       end

#     else
#       { alert: "You don't have enough coins" }
#     end
#   else
#     render 'user_skills/show'
#   end
# end
