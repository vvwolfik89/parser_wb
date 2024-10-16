class ProductsController < ApplicationController
  def index
    @parts = Product.all#.with_field_keyword(params[:keyword])
  end

  def show
    @part = Part.includes(:data_ratings).find(params[:id])
    @data_ratings = @part.data_ratings
    respond_to do |format|
      format.xlsx {
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename=items.xlsx"
      }
      format.html { render :show }
    end
  end

  def new
    @part = Part.new
  end

  def create
    @part = Part.new(resource_params)

    if @part.save
      redirect_to @part
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])
    respond_to do |format|
      if @part.update(resource_params)
        # @user.avatar.attach(params[:avatar])
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @part.destroy

    respond_to do |format|
      format.html { redirect_to parts_url }
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
    params.require(:part).permit(:title, :brand, :describe, :detail_num, :o_e)
  end
end
