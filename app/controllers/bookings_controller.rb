class BookingsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_booking, except: [ :create, :detroy ]
  before_action :set_chatroom, except: [ :show, :create, :edit ]

  def show
    authorize @booking
  end

  def create
    @user_skill = UserSkill.find(params[:user_skill_id])
    @skill = @user_skill.skill.name
    @booking = Booking.new(booking_params)
    @booking.user_skill = @user_skill
    @booking.skill = @skill
    @booking.status = 'Pending'
    @booking.student = current_user
    @booking.teacher = @user_skill.user
    @booking.remote = params[:booking][:remote] == '0' ? false : true
    authorize @booking
    if @booking.save
      if @booking.student.points >= 10
        @booking.student.points -= 10
        @booking.student.save
        @chatroom = Chatroom.where(teacher: @booking.teacher.id, student: @booking.student.id).or(Chatroom.where(teacher: @booking.student.id, student: @booking.teacher.id))
        if !@chatroom.present?
          @chatroom = Chatroom.create(student: current_user, teacher: @booking.teacher)
          redirect_to chatroom_path(@chatroom, chat: @chatroom.id), alert: "Your booking request has been sent"
        else
          @chatroom
          redirect_to chatroom_path(@chatroom, chat: @chatroom.ids.first), alert: "Your booking request has been sent"
        end

      else
        { alert: "You don't have enough coins" }
      end
    else
      render 'user_skills/show'
    end
  end

  def destroy
    @booking.destroy
    authorize @booking
    if @booking.status == 'Accepted'
      @booking.student.points += 10
      @booking.teacher.points -= 10
    elsif @booking.status == 'Pending'
      @booking.student.points += 10
    end
    @booking.student.save
    @booking.teacher.save
    redirect_to chatroom_path(@chatroom, chat: @chatroom.ids.first), :alert => "Your booking has been deleted"
  end

  def edit
  end

  def update
    if params[:status] == 'Accepted'
      @booking.date = params[:booking][:date]
      if @booking.status == 'Rejected'
        @booking.teacher.points += 10
        @booking.student.points -= 10
      elsif @booking.status == 'Accepted'
        @booking.teacher.points -= 0
        @booking.student.points += 0
      elsif @booking.status == 'Pending'
        @booking.teacher.points += 10
      end
      @booking.student.save
      @booking.teacher.save
    end
    if params[:status] == 'Rejected'
      if @booking.status == 'Rejected'
        @booking.teacher.points += 0
        @booking.student.points += 0
      elsif @booking.status == 'Accepted'
        @booking.teacher.points -= 10
        @booking.student.points += 10
      elsif @booking.status == 'Pending'
        @booking.student.points += 10
      end
      @booking.student.save
      @booking.teacher.save
    end
    @booking.status = params[:status]
    authorize @booking
    if @booking.save
      redirect_to chatroom_path(@chatroom, chat: @chatroom.ids.first)
    else
      render 'user_skills/show'
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.where(teacher: @booking.teacher.id, student: @booking.student.id).or(Chatroom.where(teacher: @booking.student.id, student: @booking.teacher.id))
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:remote, :message, :date)
  end
end
