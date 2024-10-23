class ProductsController < ApplicationController
  def index
    @products = Product.all#.with_field_keyword(params[:keyword])
  end

  def show
    # @product = Product.includes(:data_ratings).find(params[:id])
    @product = Product.find(params[:id])
    # @data_ratings = @product.data_ratings
    respond_to do |format|
      # format.xlsx {
      #   response.headers[
      #     'Content-Disposition'
      #   ] = "attachment; filename=items.xlsx"
      # }
      format.html { render :show }
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(resource_params)

    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update(resource_params)
        # @user.avatar.attach(params[:avatar])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  def daily_report
    service = Reports::DailyReportService.new(current_date_range)
    @value = service.build_data
    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename=\"daily_report-#{current_date_range}.xlsx\""
      }
      format.html { render 'shared/reports/daily_report', locals: { value: @value } }
    end
  end

  private
  def resource_params
    params.require(:product).permit(:title, :num, :count, :body)
  end
end
