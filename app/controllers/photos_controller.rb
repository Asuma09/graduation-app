class PhotosController < ApplicationController
  def index
    @photos = Photo.all.order(created_at: :desc)
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user

    if @photo.save
      redirect_to photos_path, notice: "写真をアップロードしました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # URLの番号（id）から、編集したい特定の写真データを探してくる
    @photo = Photo.find(params[:id])
  end

  def update
    # 編集したい写真を探してきて、新しいデータで上書き保存する
    @photo = Photo.find(params[:id])
    if @photo.update(photo_params)
      redirect_to photos_path, notice: "写真を更新しました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # 削除したい写真を探してきて、データベースから消し去る
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to photos_path, notice: "写真を削除しました！"
  end

  private

  def photo_params
    # image を許可するのがポイントです！
    params.require(:photo).permit(:event_date, :content, :image)
  end
end
