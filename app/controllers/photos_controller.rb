class PhotosController < ApplicationController
  def index
    @photos = Photo.all.order(created_at: :desc)
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = User.first # 仮のユーザー

    if @photo.save
      redirect_to photos_path, notice: "写真をアップロードしました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def photo_params
    # image を許可するのがポイントです！
    params.require(:photo).permit(:event_date, :content, :image)
  end
end
