module ApplicationHelper
  def qr_code(text)
    qr = RQRCode::QRCode.new(text)

    qr.as_svg(fill: :white, module_size: 5).html_safe
  end
end
