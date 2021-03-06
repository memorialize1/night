class UsersController < ApplicationController

    def index
        @users = User.page(params[:page]).reverse_order
    end

    def show
        @user = User.find(params[:id])
        @boards = @user.boards
        if @user.genre_id == nil
            @genre = "bag"
        else
            @genre = Genre.find(@user.genre_id)
        end


    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            if current_user.image.present?
                input_tags = Vision.get_image_data(@user.image)
                @user.tags.each do |tag|
                    tag.destroy
                end
                input_tags.each do |tag|
                  # sudocode
                  #if Tag.all.map(&:name).include?(tag.name)
                  #  tag = Tag.find_by(name: tag.name)
                  #  @user.tags << tag
                  #else
                  #  @user.tags << Tag.new(name: tag)
                  #end
                  @user.tags.create(name: tag)
                end
                # @user.tags.save
            end
        redirect_to user_path(current_user.id), notice: "You have updated user successfully."
        else
            render "edit"
        end
    end


    def withdrow #退会画面を表示するアクション
       @user = User.find(params[:id])
    end

    def switch
       @user = User.find(params[:id])
       if @user.update(user_status: false)
          sign_out current_user #URLを踏ませずにコントローラーから直接サインアウトの指示を出す（device公式)
       end
       redirect_to root_path
    end




    private
    def user_params
        params.require(:user).permit(:name, :introduction, :image, :code, :genre_id)
    end

    def ensure_correct_user
            @user = User.find(params[:id])
        unless @user == current_user
            redirect_to user_path(current_user)
        end

    end


end
