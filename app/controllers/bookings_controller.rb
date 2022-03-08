class BookingsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @user_skill = UserSkill.find(params[:user_skill_id])
    @skill = @user_skill.skill.name
    @booking = Booking.new(booking_params)
    @booking.user_skill = @user_skill
    @booking.skill = @skill
    @booking.status = 'pending'
    @booking.student = current_user
    @booking.teacher = @user_skill.user
    @booking.remote = params[:booking][:remote] == '0' ? false : true
    authorize @booking
    if @booking.save
      if @booking.student.points >= 10
        @booking.student.points -= 10
        @booking.student.save
        @booking.teacher.points += 10
        @booking.teacher.save
        redirect_to dashboard_path
      else
        ## add alert
      end
    else
      render 'user_skills/show'
    end
  end

  def destroy
    @booking = Booking.find(params[:id]).destroy
    authorize @booking
    @booking.student.points += 10
    @booking.student.save
    @booking.teacher.points -= 10
    @booking.teacher.save

    redirect_to dashboard_path :notice => "Your booking has been deleted"
  end

  private

  def booking_params
    params.require(:booking).permit(:remote, :message, :date)
  end
end
