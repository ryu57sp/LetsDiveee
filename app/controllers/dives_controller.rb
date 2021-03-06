class DivesController < ApplicationController
  before_action :set_q, only: [:index, :search]

  def new
    @dive = Dive.new
  end

  def create
    @dive = Dive.new(dive_params)
    @dive.user_id = current_user.id
    if @dive.save
      redirect_to dives_path
    else
      flash[:error] = '投稿に失敗しました。未記入の項目があります。'
      render :new
    end
  end

  def index
    @dives = Dive.includes(:user).order('id DESC').page(params[:page]).per(4)
  end

  def show
    @dive = Dive.find(params[:id])
    @dive_comment = DiveComment.new
    impressionist(@dive, nil, unique: [:impressionable_id, :ip_address])
  end

  def edit
    @dive = Dive.find(params[:id])
    unless @dive.user == current_user
      redirect_to dives_path
    end
  end

  def update
    @dive = Dive.find(params[:id])
    if @dive.update(dive_params)
      redirect_to dives_path
    end
  end

  def destroy
    @dive = Dive.find(params[:id])
    @dive.destroy
    redirect_to dives_path
  end

  def hashtag
    @user = current_user
    @tag = Hashtag.find_by(hashname: params[:name])
    @dives = @tag.dives.order('dive_id DESC').includes(:user).page(params[:page]).per(4)
  end

  def search
    @results = @q.result.order('id DESC').page(params[:page]).per(4)
  end

  private

  def set_q
    @q = Dive.includes(:user).ransack(params[:q])
  end

  def dive_params
    params.require(:dive).permit(:image, :dive_point, :title, :body, :water_temperature, :maximum_depth, :season, :dive_shop)
  end
end
