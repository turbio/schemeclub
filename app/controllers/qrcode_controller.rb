require 'rqrcode'

class QrcodeController < ApplicationController
	def index
		@data = RQRCode::QRCode.new params[:data]

		@width = params[:width] || 200
		@height = params[:height] || 200

		@blocks_wide = @data.modules.length
		@blocks_high = @data.modules.length

		@block_width = 1
		@block_height = 1

		headers['Content-Type'] = 'image/svg+xml'
		render layout: false
	end
end
