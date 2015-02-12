class Admin::ApiUsersController < AdminController
  load_and_authorize_resource
  before_action :set_api_user, only: [:show, :edit, :update, :destroy]

  def index
    @q = ApiUser.includes(:registrar).search(params[:q])
    @api_users = @q.result.page(params[:page])
  end

  def new
    @api_user = ApiUser.new
  end

  def create
    app = api_user_params
    app[:csr] = params[:api_user][:csr].open.read if params[:api_user][:csr]

    @api_user = ApiUser.new(app)

    if @api_user.save
      flash[:notice] = I18n.t('record_created')
      redirect_to [:admin, @api_user]
    else
      flash.now[:alert] = I18n.t('failed_to_create_record')
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    app = api_user_params
    app[:csr] = params[:api_user][:csr].open.read if params[:api_user][:csr]

    if @api_user.update(app)
      flash[:notice] = I18n.t('record_updated')
      redirect_to [:admin, @api_user]
    else
      flash.now[:alert] = I18n.t('failed_to_update_record')
      render 'edit'
    end
  end

  def destroy
    if @api_user.destroy
      flash[:notice] = I18n.t('record_deleted')
      redirect_to admin_api_users_path
    else
      flash.now[:alert] = I18n.t('failed_to_delete_record')
      render 'show'
    end
  end

  def download_csr
    send_data @api_user.csr, filename: "#{@api_user.username}.csr.pem"
  end

  def download_crt
    send_data @api_user.crt, filename: "#{@api_user.username}.crt.pem"
  end

  private

  def set_api_user
    @api_user = ApiUser.find(params[:id])
  end

  def api_user_params
    params.require(:api_user).permit(:username, :password, :csr, :active, :registrar_id, :registrar_typeahead)
  end
end