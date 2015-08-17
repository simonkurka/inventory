class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
  end

  # GET /items/1
  # GET /items/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.pdf { render body: to_pdf, content_type: 'application/pdf' }
      format.png { render body: to_png, content_type: 'image/png' }
    end
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def label
    @item = Item.find(params[:id])
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:code, :name, :description)
    end

    def get_barcode
      require 'barby'
      require 'barby/barcode/code_39'
      require 'barby/outputter/cairo_outputter'
      barcode = Barby::Code39.new(@item.id.to_s(36).upcase.rjust(4, '0'))
      barcode.include_checksum = true
      barcode
    end
    
    def to_png
      output_to_string_io do |io|
        Cairo::ImageSurface.new(nil, 101 * dimen(:png), 54 * dimen(:png)) do |surface|
          render_cairo(surface, :png, 101, 54)
          surface.write_to_png(io)
        end
      end
    end

    def to_pdf
      output_to_string_io do |io|
        Cairo::PDFSurface.new(io, 101 * dimen(:pdf), 54 * dimen(:pdf)) do |surface|
          render_cairo(surface, :pdf, 101, 54)
        end
      end
    end

    def dimen(format)
      # 1 Point = 1/72 inch in cairo
      # 1 Point = 1/96 inch in many browsers
      if format == :pdf
        dpi = 72
      else
        dpi = 96
      end
      # 1 Inch = 25.4 mm
      (dpi / 25.4)
    end

    def render_cairo(surface, format, width, height)
      cr = Cairo::Context.new(surface)
      yield(cr) if block_given?
      cr.set_source_color(:white)
      cr.paint

      barcode = get_barcode
      outputter = barcode.outputter_for :render_to_cairo_context

      extents = cr.text_extents(barcode.data);

      options = {:margin => 0, :x => (width - 5) * dimen(format) - outputter.width, :y => 2.5 * dimen(format), :height => (height - 5) * dimen(format) - extents.height - dimen(format)}
      outputter.render_to_cairo_context(cr, options)

      cr.select_font_face("Georgia", Cairo::FONT_SLANT_NORMAL, Cairo::FONT_WEIGHT_BOLD)
      cr.set_font_size(12)
      cr.set_source_rgb(0, 0, 0)

      cr.move_to(outputter.x(options) + ((outputter.width(options) - extents.width) / 2), outputter.y(options) + outputter.height(options) + extents.height + dimen(format))
      cr.show_text(barcode.data)

      cr
    end

    def output_to_string_io
      io = StringIO.new
      yield(io)
      io.rewind
      io.read
    end

end
